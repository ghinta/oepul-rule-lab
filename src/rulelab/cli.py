from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import os
import platform
import re
import select
import shutil
import signal
import subprocess
import sys
import tempfile
import time
import urllib.request
import uuid
from pathlib import Path
from typing import Any

from .contracts import (
    GENERATOR_CONTRACT_MODELS,
    RunArtifactV1,
    export_generator_schemas,
    validate_model_config,
)
from .grounding import known_profile_paths, validate_grounded_outputs


REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_PROFILE = REPO_ROOT / "profiles" / "canonical_farm_profile.json"
DEFAULT_SOURCES = REPO_ROOT / "sources" / "oepul"
OPA_RUNNER = REPO_ROOT / "runner" / "validation" / "opa_validate.py"
OPA_VERSION_FILE = OPA_RUNNER.parent / "opa-version.txt"
OPA_CHECKSUMS_FILE = OPA_RUNNER.parent / "opa-checksums.json"
OPA_VALIDATION_TARGETS = ("policy", "data", "tests")
GENERATOR_CONTRACTS = tuple(GENERATOR_CONTRACT_MODELS)
MIN_START_REMAINING_PERCENT = 50.0
STOP_REMAINING_PERCENT = 5.0
USAGE_POLL_SECONDS = 30.0
USAGE_GUARD_EXIT_CODE = 75
USAGE_GUARDED_ADAPTERS = ("codex-cli", "claude-cli")
CLAUDE_USAGE_PROBE_MODEL = "claude-haiku-4-5-20251001"
CLAUDE_TOKEN_FILE_ENV = "RULELAB_CLAUDE_OAUTH_TOKEN_FILE"
# Variables a nested Claude Code generator must not inherit: host-session
# wiring (CLAUDE*), a host thinking budget that would override the configured
# effort, and forge credentials the generator has no use for.
CLAUDE_ENV_KEEP = frozenset({"CLAUDE_CODE_OAUTH_TOKEN", "CLAUDE_CONFIG_DIR"})
CLAUDE_ENV_DROP = frozenset({"MAX_THINKING_TOKENS", "GH_TOKEN", "GITHUB_TOKEN"})
CLAUDE_DISALLOWED_TOOLS = (
    "WebFetch",
    "WebSearch",
    "Bash(git *)",
    "Bash(gh *)",
    "Bash(curl *)",
    "Bash(wget *)",
    "Bash(docker *)",
)
CLAUDE_RESUME_PROMPT = """\
Der vorherige Generatorlauf wurde durch den Rule-Lab-Nutzungsguard oder eine
Unterbrechung kontrolliert beendet. Setze den ursprünglichen Auftrag im
aktuellen Run-Workspace fort: Prüfe zuerst den vorhandenen Stand aller
Ausgaben, vervollständige fehlende Regeln, Belege, Coverage-Einträge, Daten,
Rego-Module und Tests und führe die Validierung erneut aus. Bereits korrekte
Ergebnisse bleiben erhalten.
"""


class UsageGuardError(ValueError):
    """Raised when provider usage cannot safely satisfy the configured guard."""


class CodexRateLimitClient:
    """Small JSON-RPC client for Codex App Server rate-limit reads."""

    def __init__(self, executable: str) -> None:
        self.executable = executable
        self.process: subprocess.Popen[str] | None = None
        self.next_request_id = 1

    def __enter__(self) -> "CodexRateLimitClient":
        self.process = subprocess.Popen(
            [self.executable, "app-server"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            encoding="utf-8",
            errors="replace",
            bufsize=1,
        )
        self.request(
            "initialize",
            {
                "clientInfo": {
                    "name": "oepul-rule-lab",
                    "title": "ÖPUL Rule Lab usage guard",
                    "version": "1.0",
                }
            },
        )
        self.notify("initialized", {})
        return self

    def __exit__(self, *_: Any) -> None:
        if self.process is None:
            return
        if self.process.poll() is None:
            self.process.terminate()
            try:
                self.process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.process.kill()
                self.process.wait(timeout=5)

    def notify(self, method: str, params: dict[str, Any]) -> None:
        self._send({"method": method, "params": params})

    def request(self, method: str, params: dict[str, Any]) -> dict[str, Any]:
        request_id = self.next_request_id
        self.next_request_id += 1
        self._send({"method": method, "id": request_id, "params": params})
        deadline = time.monotonic() + 15
        while True:
            message = self._read_message(deadline)
            if message.get("id") != request_id:
                continue
            if "error" in message:
                raise UsageGuardError(
                    f"Codex usage read failed: {message['error']}"
                )
            result = message.get("result")
            if not isinstance(result, dict):
                raise UsageGuardError("Codex usage read returned no result object")
            return result

    def remaining_percent(self) -> float:
        return rate_limit_remaining_percent(
            self.request("account/rateLimits/read", {})
        )

    def _send(self, message: dict[str, Any]) -> None:
        if self.process is None or self.process.stdin is None:
            raise UsageGuardError("Codex usage client is not running")
        if self.process.poll() is not None:
            raise UsageGuardError("Codex usage client stopped unexpectedly")
        self.process.stdin.write(json.dumps(message) + "\n")
        self.process.stdin.flush()

    def _read_message(self, deadline: float) -> dict[str, Any]:
        if self.process is None or self.process.stdout is None:
            raise UsageGuardError("Codex usage client is not running")
        remaining = deadline - time.monotonic()
        if remaining <= 0:
            raise UsageGuardError("Timed out while reading Codex usage")
        readable, _, _ = select.select([self.process.stdout], [], [], remaining)
        if not readable:
            raise UsageGuardError("Timed out while reading Codex usage")
        line = self.process.stdout.readline()
        if not line:
            raise UsageGuardError("Codex usage client closed its output")
        try:
            message = json.loads(line)
        except json.JSONDecodeError as exc:
            raise UsageGuardError("Codex usage client returned invalid JSON") from exc
        if not isinstance(message, dict):
            raise UsageGuardError("Codex usage client returned a non-object message")
        return message


def rate_limit_remaining_percent(result: dict[str, Any]) -> float:
    """Return remaining capacity of the Codex five-hour (primary) window only."""

    by_limit = result.get("rateLimitsByLimitId")
    if isinstance(by_limit, dict) and by_limit:
        bucket = by_limit.get("codex")
        if not isinstance(bucket, dict) and len(by_limit) == 1:
            bucket = next(iter(by_limit.values()))
    else:
        bucket = result.get("rateLimits")

    if not isinstance(bucket, dict):
        raise UsageGuardError("Codex usage returned no readable primary rate-limit window")
    primary = bucket.get("primary")
    if not isinstance(primary, dict):
        raise UsageGuardError("Codex usage returned no readable primary rate-limit window")
    used = primary.get("usedPercent")
    if isinstance(used, bool) or not isinstance(used, (int, float)):
        raise UsageGuardError(f"Codex usage returned invalid usedPercent: {used!r}")
    if not 0 <= float(used) <= 100:
        raise UsageGuardError(f"Codex usage returned invalid usedPercent: {used!r}")
    return 100.0 - float(used)


class ClaudeRateLimitProbe:
    """Read Claude plan limits through a minimal tool-less ``claude -p`` call.

    Claude Code emits a ``rate_limit_event`` with the unified subscription
    windows after its first API response. A one-token reply from a small model
    therefore reads the same limits the generator consumes, using whatever
    authentication the local ``claude`` installation already has.
    """

    def __init__(
        self,
        executable: str,
        environment: dict[str, str],
        model: str = CLAUDE_USAGE_PROBE_MODEL,
    ) -> None:
        self.executable = executable
        self.environment = environment
        self.model = model

    def __enter__(self) -> "ClaudeRateLimitProbe":
        return self

    def __exit__(self, *_: Any) -> None:
        return None

    def command(self) -> list[str]:
        return [
            self.executable,
            "-p",
            ".",
            "--model",
            self.model,
            "--tools",
            "",
            "--system-prompt",
            "Reply with a single dot.",
            "--output-format",
            "stream-json",
            "--verbose",
            "--no-session-persistence",
            "--strict-mcp-config",
            "--setting-sources",
            "",
            "--disable-slash-commands",
        ]

    def remaining_percent(self) -> float:
        try:
            completed = subprocess.run(
                self.command(),
                capture_output=True,
                text=True,
                encoding="utf-8",
                errors="replace",
                timeout=90,
                check=False,
                cwd=tempfile.gettempdir(),
                env=self.environment,
                stdin=subprocess.DEVNULL,
            )
        except (OSError, subprocess.TimeoutExpired) as exc:
            raise UsageGuardError(f"Claude usage probe failed: {exc}") from exc
        info: dict[str, Any] | None = None
        for line in completed.stdout.splitlines():
            try:
                event = json.loads(line)
            except json.JSONDecodeError:
                continue
            if isinstance(event, dict) and event.get("type") == "rate_limit_event":
                candidate = event.get("rate_limit_info")
                if isinstance(candidate, dict):
                    info = candidate
        if info is None:
            raise UsageGuardError(
                "Claude usage probe returned no rate_limit_event "
                f"(exit code {completed.returncode})"
            )
        return claude_rate_limit_remaining_percent(info)


def claude_rate_limit_remaining_percent(info: dict[str, Any]) -> float:
    """Return remaining capacity of the Claude five-hour window only.

    The weekly window is not a start or stop gate, matching the Codex guard. A
    ``rejected`` status still means no capacity at all, whichever window caused
    it, so the generator stops in a resumable state instead of failing hard.
    """

    if info.get("status") == "rejected":
        return 0.0
    windows = info.get("unifiedWindows")
    window = windows.get("five_hour") if isinstance(windows, dict) else None
    if not isinstance(window, dict):
        raise UsageGuardError("Claude usage returned no readable five_hour window")
    utilization = window.get("utilization")
    if isinstance(utilization, bool) or not isinstance(utilization, (int, float)):
        raise UsageGuardError(
            f"Claude usage returned invalid five_hour utilization: {utilization!r}"
        )
    if utilization < 0:
        raise UsageGuardError(
            f"Claude usage returned invalid five_hour utilization: {utilization!r}"
        )
    return 100.0 * (1.0 - min(float(utilization), 1.0))


def read_json(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        value = json.load(handle)
    if not isinstance(value, dict):
        raise ValueError(f"Expected a JSON object in {path}")
    return value


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, ensure_ascii=False, indent=2, sort_keys=True)
        handle.write("\n")


def write_run_metadata(path: Path, value: dict[str, Any]) -> None:
    """Reject malformed lifecycle metadata before it becomes run evidence."""
    # Pre-v2 historical fixtures/runs without the lifecycle contract remain
    # readable; every run prepared by the current CLI carries the contract and
    # is validated at each persisted transition.
    if "contract_version" in value:
        RunArtifactV1.model_validate(value)
    write_json(path, value)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def opa_platform_key() -> str:
    system = platform.system().lower()
    machine = platform.machine().lower()
    architecture = {
        "aarch64": "arm64",
        "arm64": "arm64",
        "amd64": "amd64",
        "x86_64": "amd64",
    }.get(machine)
    if system not in {"darwin", "linux"} or architecture is None:
        raise ValueError(
            f"Unsupported OPA bootstrap platform: {system}/{machine}. "
            "Set OPA_BIN to a pinned compatible executable."
        )
    return f"{system}-{architecture}"


def verify_opa_binary(path: Path, expected_version: str) -> None:
    try:
        completed = subprocess.run(
            [str(path), "version"],
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=20,
            check=False,
        )
    except (OSError, subprocess.TimeoutExpired) as exc:
        raise ValueError(f"Could not execute OPA binary {path}: {exc}") from exc
    match = re.search(r"^Version:\s*(\S+)", completed.stdout, re.MULTILINE)
    actual = match.group(1) if match else None
    if completed.returncode != 0 or actual != expected_version:
        raise ValueError(
            f"OPA binary {path} has version {actual!r}; "
            f"expected {expected_version!r}"
        )


def download_pinned_opa(target: Path, expected_version: str) -> dict[str, str]:
    checksums = read_json(OPA_CHECKSUMS_FILE)
    platform_key = opa_platform_key()
    version_specs = checksums.get(expected_version)
    if not isinstance(version_specs, dict):
        raise ValueError(f"No pinned OPA checksums for version {expected_version}")
    spec = version_specs.get(platform_key)
    if not isinstance(spec, dict):
        raise ValueError(
            f"No pinned OPA asset for version {expected_version} on {platform_key}"
        )
    asset = str(spec["asset"])
    expected_sha256 = str(spec["sha256"])
    url = f"https://openpolicyagent.org/downloads/v{expected_version}/{asset}"
    target.parent.mkdir(parents=True, exist_ok=True)
    temporary: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(dir=target.parent, delete=False) as handle:
            temporary = Path(handle.name)
            with urllib.request.urlopen(url, timeout=180) as response:
                shutil.copyfileobj(response, handle)
        if sha256(temporary) != expected_sha256:
            raise ValueError(f"Checksum mismatch for downloaded OPA asset {asset}")
        temporary.chmod(0o755)
        verify_opa_binary(temporary, expected_version)
        os.replace(temporary, target)
        temporary = None
    finally:
        if temporary is not None and temporary.exists():
            temporary.unlink()
    return {
        "source": "official-download",
        "asset": asset,
        "url": url,
        "platform": platform_key,
        "sha256": expected_sha256,
    }


def stage_workspace_opa(
    workspace: Path, *, cache_root: Path | None = None
) -> dict[str, Any]:
    version_file = workspace / "tools" / "opa-version.txt"
    if not version_file.is_file():
        raise ValueError(f"Missing pinned OPA version file: {version_file}")
    expected_version = version_file.read_text(encoding="utf-8").strip()
    if not expected_version:
        raise ValueError(f"Pinned OPA version is empty: {version_file}")

    configured = os.environ.get("OPA_BIN")
    configured_path = shutil.which(configured) if configured else None
    host_candidate = (
        Path(configured_path or configured).expanduser().resolve()
        if configured
        else None
    )
    source: dict[str, Any] | None = None
    if host_candidate is not None:
        verify_opa_binary(host_candidate, expected_version)
        source = {"source": "OPA_BIN", "path": str(host_candidate.resolve())}
    else:
        discovered = shutil.which("opa")
        if discovered:
            candidate: Path | None = Path(discovered).resolve()
            try:
                verify_opa_binary(candidate, expected_version)
            except ValueError:
                candidate = None
            if candidate is not None:
                host_candidate = candidate
                source = {"source": "PATH", "path": str(candidate)}

    if host_candidate is None:
        platform_key = opa_platform_key()
        cache = cache_root or REPO_ROOT / ".rulelab-cache" / "opa"
        cached = cache / expected_version / platform_key / "opa"
        if cached.is_file():
            try:
                verify_opa_binary(cached, expected_version)
            except ValueError:
                source = download_pinned_opa(cached, expected_version)
            else:
                source = {
                    "source": "verified-cache",
                    "path": str(cached.resolve()),
                    "platform": platform_key,
                    "sha256": sha256(cached),
                }
        else:
            source = download_pinned_opa(cached, expected_version)
        host_candidate = cached

    destination = workspace / "tools" / "opa"
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(host_candidate, destination)
    destination.chmod(0o755)
    verify_opa_binary(destination, expected_version)
    return {
        "version": expected_version,
        "workspace_path": "workspace/tools/opa",
        "sha256": sha256(destination),
        "self_test_available": True,
        **(source or {}),
    }


def generator_environment(workspace: Path) -> dict[str, str]:
    """Return the environment exposed to a model generator.

    A model run is intentionally sandboxed to its run workspace.  Relying on
    a host-level ``opa`` executable (or on Docker) therefore makes the same
    prompt behave differently depending on the host.  ``run_agent`` stages a
    verified binary at ``tools/opa`` first; this helper makes that capability
    explicit and discoverable for both ``opa ...`` and the Python validator.
    """

    tools = (workspace / "tools").resolve()
    opa = tools / "opa"
    environment = os.environ.copy()
    environment["OPA_RUNTIME"] = "local"
    environment["OPA_BIN"] = str(opa)
    environment["PATH"] = os.pathsep.join(
        item for item in (str(tools), environment.get("PATH", "")) if item
    )
    environment["RULELAB_OPA_RUNTIME"] = "local"
    environment["RULELAB_OPA_BIN"] = "tools/opa"
    return environment


def claude_environment(base: dict[str, str]) -> dict[str, str]:
    """Return a generator environment detached from any host Claude session.

    When Rule Lab itself runs inside Claude Code, the inherited ``CLAUDE*``
    variables would wire the nested generator into the host session. An
    optional ``RULELAB_CLAUDE_OAUTH_TOKEN_FILE`` supplies a token for hosts
    whose own login is not visible to a child process; the token is passed via
    the environment only and never written to run metadata.
    """

    environment = {
        key: value
        for key, value in base.items()
        if key in CLAUDE_ENV_KEEP
        or not (key.startswith("CLAUDE") or key in CLAUDE_ENV_DROP)
    }
    token_file = environment.pop(CLAUDE_TOKEN_FILE_ENV, None)
    if token_file and "CLAUDE_CODE_OAUTH_TOKEN" not in environment:
        token = Path(token_file).expanduser().read_text(encoding="utf-8").strip()
        if not token:
            raise ValueError(f"{CLAUDE_TOKEN_FILE_ENV} points to an empty file")
        environment["CLAUDE_CODE_OAUTH_TOKEN"] = token
    return environment


def extract_pdf_text(source: Path, target: Path) -> None:
    try:
        from pypdf import PdfReader
    except ImportError as exc:
        raise ValueError(
            "PDF text extraction requires pypdf; run `python3 -m pip install -e .`"
        ) from exc
    reader = PdfReader(source)
    pages = []
    for number, page in enumerate(reader.pages, start=1):
        pages.append(f"\n===== PAGE {number} =====\n\n{page.extract_text() or ''}")
    target.write_text("".join(pages).lstrip() + "\n", encoding="utf-8")


def utc_now() -> str:
    return dt.datetime.now(dt.UTC).replace(microsecond=0).isoformat()


def display_path(path: Path, root: Path) -> str:
    """Prefer a repository-relative provenance path, with a safe absolute fallback."""
    try:
        return str(path.resolve().relative_to(root.resolve()))
    except ValueError:
        return str(path.resolve())


def default_run_id(measure: str, model: str) -> str:
    stamp = dt.datetime.now(dt.UTC).strftime("%Y%m%dT%H%M%SZ")
    safe_model = re.sub(r"[^a-zA-Z0-9_.-]+", "-", model).strip("-")
    return f"{stamp}__{measure}__{safe_model}"


def source_files(source_root: Path, measure: str, all_sources: bool) -> list[Path]:
    candidates = sorted(
        path
        for path in source_root.rglob("*")
        if path.is_file()
        and path.suffix.lower() in {".pdf", ".html"}
        and "provenance" not in path.parts
    )
    if all_sources:
        return candidates

    manifest_path = source_root / "manifest.json"
    if manifest_path.is_file():
        manifest = read_json(manifest_path)
        records = [
            *manifest.get("documents", []),
            *manifest.get("legal_basis_documents", []),
            *manifest.get("year_specific_notices", []),
        ]
        selected_from_manifest: list[Path] = []
        for record in records:
            if not isinstance(record, dict):
                continue
            include = (
                record.get("measure_id") == measure
                or record.get("document_id") == "o6_general"
                or record.get("source_type")
                in {"legal_basis_pdf", "year_specific_notice_html"}
            )
            if not include:
                continue
            local_path = record.get("local_path")
            if not isinstance(local_path, str):
                continue
            candidate = (REPO_ROOT / local_path).resolve()
            try:
                candidate.relative_to(source_root.resolve())
            except ValueError as exc:
                raise ValueError(
                    f"Source manifest path escapes source root: {local_path}"
                ) from exc
            if candidate.is_file():
                selected_from_manifest.append(candidate)
        if selected_from_manifest:
            return sorted(set(selected_from_manifest))

    needle = measure.lower()
    selected = [
        path
        for path in candidates
        if needle in path.name.lower()
        or "allgemeine_teilnahmebedingungen" in path.name.lower()
        or "allgemeine-teilnahmebedingungen" in path.name.lower()
        or "legal" in path.parts
        or "notices" in path.parts
    ]
    return selected


# Quality Gate v2 is opt-in (`prepare --quality-gate v2`): v1 runs keep the
# prompt they were compared on, without this step.
QUALITY_GATE_V2_PROMPT_STEP = """
10. Lies `contracts/execution-evidence-v1.schema.json` und schreibe
    `rules/execution_evidence.json`. Erfasse jede Katalogregel genau einmal:
    `executable` benötigt direkte Rego-Stellen, dieselben Quellenbeleg-IDs wie
    die Regel sowie mindestens einen positiven und einen negativen oder
    Grenzfall-Test mit Symbol und Zeilenbereich. Regeln, die noch nicht
    ausführbar sind, müssen stattdessen als `documented_only` oder `unresolved`
    mit einer konkreten Begründung ausgewiesen werden. Behaupte keine
    Ausführbarkeit, wenn kein direkter Quellen--Code--Test-Nachweis möglich ist."""


def render_prompt(template: str, values: dict[str, str]) -> str:
    for key, value in values.items():
        template = template.replace("{{" + key + "}}", value)
    return template


def prepare(args: argparse.Namespace) -> int:
    model_path = Path(args.model).resolve()
    model_config = validate_model_config(read_json(model_path)).model_dump(
        mode="json"
    )
    model_name = str(model_config.get("model", "unknown-model"))
    run_id = args.run_id or default_run_id(args.measure, model_name)
    run_dir = (REPO_ROOT / "runs" / run_id).resolve()
    if run_dir.exists():
        raise FileExistsError(f"Run already exists: {run_dir}")

    profile_path = Path(args.profile).resolve()
    source_root = Path(args.sources).resolve()
    selected_sources = source_files(source_root, args.measure, args.all_sources)
    if not selected_sources:
        raise FileNotFoundError(
            f"No source documents found for {args.measure} below {source_root}. "
            "Update the source pack first or use --all-sources."
        )

    workspace = run_dir / "workspace"
    for relative in (
        "policy",
        "data",
        "tests",
        "rules",
        "notes",
        "sources",
        "tools",
        "contracts",
    ):
        (workspace / relative).mkdir(parents=True, exist_ok=True)
    (run_dir / "raw").mkdir(parents=True)
    (run_dir / "artifacts").mkdir(parents=True)

    shutil.copy2(profile_path, run_dir / "baseline_profile.json")
    shutil.copy2(profile_path, workspace / "canonical_farm_profile.json")
    shutil.copy2(REPO_ROOT / "AGENTS.md", workspace / "AGENTS.md")
    shutil.copy2(model_path, run_dir / "model.json")
    for contract_name in GENERATOR_CONTRACTS:
        contract = REPO_ROOT / "contracts" / contract_name
        if not contract.is_file():
            raise FileNotFoundError(f"Missing generator contract: {contract}")
        shutil.copy2(contract, workspace / "contracts" / contract_name)
    if OPA_RUNNER.is_file():
        shutil.copy2(OPA_RUNNER, workspace / "tools" / "opa_validate.py")
        if OPA_VERSION_FILE.is_file():
            shutil.copy2(OPA_VERSION_FILE, workspace / "tools" / "opa-version.txt")

    source_records: list[dict[str, Any]] = []
    prompt_source_lines: list[str] = []
    for source in selected_sources:
        target = workspace / "sources" / source.name
        shutil.copy2(source, target)
        companion = None
        if source.suffix.lower() == ".pdf" and not args.skip_pdf_text:
            companion = target.with_suffix(".txt")
            extract_pdf_text(target, companion)
        source_records.append(
            {
                "name": source.name,
                "source_path": str(source.relative_to(source_root)),
                "sha256": sha256(source),
                "bytes": source.stat().st_size,
            }
        )
        line = f"- sources/{source.name}"
        if companion is not None:
            line += f" (seitenmarkierter Text: sources/{companion.name})"
        prompt_source_lines.append(line)
    source_manifest = source_root / "manifest.json"
    if source_manifest.is_file():
        shutil.copy2(source_manifest, workspace / "sources" / "manifest.json")

    prompt_template = (REPO_ROOT / "prompts" / "generate_measure.md").read_text(
        encoding="utf-8"
    )
    quality_gate = getattr(args, "quality_gate", "v1")
    prompt = render_prompt(
        prompt_template,
        {
            "MEASURE_ID": args.measure,
            "MODE": args.mode,
            "RUN_ID": run_id,
            "SOURCE_LIST": "\n".join(prompt_source_lines),
            "QUALITY_GATE_V2_STEP": (
                QUALITY_GATE_V2_PROMPT_STEP if quality_gate == "v2" else ""
            ),
        },
    )
    (run_dir / "prompt.md").write_text(prompt, encoding="utf-8")

    metadata = {
        "contract_version": "1.0",
        "run_id": run_id,
        "created_at": utc_now(),
        "status": "prepared",
        "mode": args.mode,
        "quality_gate_version": quality_gate,
        "measure": args.measure,
        "model": model_config,
        "profile": {
            "path": display_path(profile_path, REPO_ROOT),
            "sha256": sha256(profile_path),
        },
        "sources": source_records,
    }
    write_run_metadata(run_dir / "run.json", metadata)
    print(run_dir)
    return 0


def codex_command(config: dict[str, Any], run_dir: Path) -> list[str]:
    executable = str(config.get("executable", "codex"))
    command = [
        executable,
        "exec",
        "--cd",
        str(run_dir / "workspace"),
        "--model",
        str(config["model"]),
        "--sandbox",
        "workspace-write",
        "--ephemeral",
        "--ignore-user-config",
        "--json",
        "--output-last-message",
        str(run_dir / "raw" / "final-message.md"),
    ]
    if effort := config.get("reasoning_effort"):
        command.extend(["-c", f"model_reasoning_effort={json.dumps(effort)}"])
    for item in config.get("args", []):
        command.append(str(item))
    command.append("-")
    return command


def claude_command(
    config: dict[str, Any], session_id: str, *, resume: bool = False
) -> list[str]:
    """Build a headless Claude Code invocation confined to the run workspace.

    File edits are auto-accepted only inside the working directory; anything
    that would need an interactive approval is denied. Network, git and
    container tools are removed. The prompt is read from stdin.
    """

    executable = str(config.get("executable", "claude"))
    command = [
        executable,
        "-p",
        "--model",
        str(config["model"]),
        "--output-format",
        "stream-json",
        "--verbose",
        "--permission-mode",
        "acceptEdits",
        "--permission-prompts",
        "none",
        "--allowedTools",
        "Bash",
        "--disallowedTools",
        ",".join(CLAUDE_DISALLOWED_TOOLS),
        "--strict-mcp-config",
        "--setting-sources",
        "",
        "--disable-slash-commands",
    ]
    command.extend(["--resume" if resume else "--session-id", session_id])
    if effort := config.get("reasoning_effort"):
        command.extend(["--effort", str(effort)])
    for item in config.get("args", []):
        command.append(str(item))
    return command


def claude_result_summary(events_path: Path) -> dict[str, Any] | None:
    """Extract the final ``result`` event of a Claude stream-json log."""

    if not events_path.is_file():
        return None
    result: dict[str, Any] | None = None
    with events_path.open(encoding="utf-8", errors="replace") as handle:
        for line in handle:
            try:
                event = json.loads(line)
            except json.JSONDecodeError:
                continue
            if isinstance(event, dict) and event.get("type") == "result":
                result = event
    if result is None:
        return None
    return {
        key: result[key]
        for key in (
            "subtype",
            "is_error",
            "num_turns",
            "duration_ms",
            "duration_api_ms",
            "total_cost_usd",
            "usage",
            "modelUsage",
            "result",
        )
        if key in result
    }


def finalization_feedback(run_dir: Path, limit: int = 300) -> str:
    """Render the last failed finalization gates for a resumed generator.

    The generator workspace contains the OPA validator but not the grounding
    gates, so a resumed session otherwise cannot see why ``finalize`` failed.
    """

    grounding_path = run_dir / "artifacts" / "grounding-validation.json"
    metrics_path = run_dir / "artifacts" / "metrics.json"
    lines: list[str] = []
    if grounding_path.is_file():
        grounding = read_json(grounding_path)
        if grounding.get("status") == "failed":
            for category, errors in sorted(grounding.get("errors", {}).items()):
                lines.extend(f"- [{category}] {error}" for error in errors)
    if metrics_path.is_file():
        missing = [
            item
            for item in read_json(metrics_path).get("required_outputs_missing", [])
            if item != "grounding_validation_failed"
        ]
        lines.extend(f"- [required_outputs_missing] {item}" for item in missing)
    if not lines:
        return ""
    shown = lines[:limit]
    if len(lines) > limit:
        shown.append(f"- … {len(lines) - limit} weitere Fehler gleicher Art")
    return (
        "\nDie deterministische Rule-Lab-Finalisierung (`finalize`) hat den "
        "bisherigen Stand abgelehnt. Behebe alle folgenden Fehler, ohne die "
        "Anforderungen aus `AGENTS.md` und den Schemas aufzuweichen:\n\n"
        + "\n".join(shown)
        + "\n"
    )


def external_command(config: dict[str, Any], run_dir: Path) -> list[str]:
    raw = config.get("command")
    if not isinstance(raw, list) or not raw:
        raise ValueError("external-command adapter requires a non-empty command array")
    replacements = {
        "{workspace}": str(run_dir / "workspace"),
        "{prompt}": str(run_dir / "prompt.md"),
        "{run_dir}": str(run_dir),
        "{model}": str(config.get("model", "")),
    }
    return [replacements.get(str(item), str(item)) for item in raw]


def prepare_raw_attempt(raw_dir: Path) -> int:
    current = [
        raw_dir / "events.jsonl",
        raw_dir / "stderr.log",
        raw_dir / "final-message.md",
    ]
    archived_numbers = []
    for path in raw_dir.glob("*.attempt-*.*"):
        if match := re.search(r"\.attempt-(\d+)\.", path.name):
            archived_numbers.append(int(match.group(1)))
    last_archived = max(archived_numbers, default=0)
    populated = [path for path in current if path.exists() and path.stat().st_size > 0]
    if not populated:
        return last_archived + 1
    archived_attempt = last_archived + 1
    for path in populated:
        path.replace(
            path.with_name(f"{path.stem}.attempt-{archived_attempt}{path.suffix}")
        )
    return archived_attempt + 1


def run_agent(args: argparse.Namespace) -> int:
    run_dir = Path(args.run_dir).resolve()
    metadata = read_json(run_dir / "run.json")
    if "contract_version" in metadata:
        RunArtifactV1.model_validate(metadata)
    config = validate_model_config(read_json(run_dir / "model.json")).model_dump(
        mode="json"
    )
    adapter = config.get("adapter", "codex-cli")
    workspace = run_dir / "workspace"
    resume = bool(getattr(args, "resume", False))
    if resume and adapter != "claude-cli":
        raise ValueError(f"--resume is not supported by adapter {adapter}")

    model_environment = generator_environment(workspace)
    session_id: str | None = None
    if adapter == "codex-cli":
        command = codex_command(config, run_dir)
        prompt_path = run_dir / "prompt.md"
    elif adapter == "claude-cli":
        model_environment = claude_environment(model_environment)
        if resume:
            session_id = metadata.get("generator_session_id")
            if not isinstance(session_id, str) or not session_id:
                raise ValueError("Cannot resume: run.json has no generator_session_id")
            prompt_path = run_dir / "raw" / "resume-prompt.md"
        else:
            session_id = str(uuid.uuid4())
            prompt_path = run_dir / "prompt.md"
        command = claude_command(config, session_id, resume=resume)
    elif adapter == "external-command":
        command = external_command(config, run_dir)
        prompt_path = run_dir / "prompt.md"
    else:
        raise ValueError(f"Unsupported adapter: {adapter}")

    if args.dry_run:
        print(json.dumps(command, ensure_ascii=False, indent=2))
        return 0

    usage_guard = {
        "minimum_start_remaining_percent": MIN_START_REMAINING_PERCENT,
        "stop_remaining_percent": STOP_REMAINING_PERCENT,
        "poll_seconds": USAGE_POLL_SECONDS,
        "adapter": adapter,
    }
    metadata["usage_guard"] = usage_guard
    usage_client: CodexRateLimitClient | ClaudeRateLimitProbe | None = None
    if adapter in USAGE_GUARDED_ADAPTERS:
        try:
            if adapter == "codex-cli":
                usage_client = CodexRateLimitClient(
                    str(config.get("executable", "codex"))
                )
            else:
                usage_client = ClaudeRateLimitProbe(
                    str(config.get("executable", "claude")),
                    model_environment,
                    str(config.get("usage_probe_model", CLAUDE_USAGE_PROBE_MODEL)),
                )
            usage_client.__enter__()
            start_remaining = usage_client.remaining_percent()
        except (OSError, UsageGuardError) as exc:
            if usage_client is not None:
                usage_client.__exit__()
            metadata["status"] = "not_started_usage_guard"
            usage_guard["status"] = "unavailable"
            usage_guard["reason"] = str(exc)
            write_run_metadata(run_dir / "run.json", metadata)
            print(f"Rule Lab usage guard: {exc}", file=sys.stderr)
            return USAGE_GUARD_EXIT_CODE
        usage_guard["start_remaining_percent"] = start_remaining
        if start_remaining < MIN_START_REMAINING_PERCENT:
            usage_client.__exit__()
            metadata["status"] = "not_started_usage_guard"
            usage_guard["status"] = "blocked_start"
            usage_guard["reason"] = (
                f"remaining quota {start_remaining:.1f}% is below the required "
                f"{MIN_START_REMAINING_PERCENT:.0f}%"
            )
            write_run_metadata(run_dir / "run.json", metadata)
            print(f"Rule Lab usage guard: {usage_guard['reason']}", file=sys.stderr)
            return USAGE_GUARD_EXIT_CODE
    else:
        usage_guard["status"] = "not_applicable"

    if OPA_RUNNER.is_file():
        shutil.copy2(OPA_RUNNER, workspace / "tools" / "opa_validate.py")
    if OPA_VERSION_FILE.is_file():
        shutil.copy2(OPA_VERSION_FILE, workspace / "tools" / "opa-version.txt")
    opa_runtime = stage_workspace_opa(workspace)

    generation_attempt = prepare_raw_attempt(run_dir / "raw")
    if resume:
        prompt_path.write_text(
            CLAUDE_RESUME_PROMPT + finalization_feedback(run_dir), encoding="utf-8"
        )
    prompt = prompt_path.read_text(encoding="utf-8")
    metadata["status"] = "running"
    metadata["started_at"] = utc_now()
    metadata["invocation"] = command
    metadata["generation_attempt"] = generation_attempt
    metadata["opa_runtime"] = opa_runtime
    metadata["generator_environment"] = {
        "opa_runtime": model_environment["OPA_RUNTIME"],
        "opa_bin": model_environment["RULELAB_OPA_BIN"],
        "path_prefix": "tools",
    }
    if session_id is not None:
        metadata["generator_session_id"] = session_id
    if resume:
        metadata["resumed_attempts"] = [
            *metadata.get("resumed_attempts", []),
            generation_attempt,
        ]
    write_run_metadata(run_dir / "run.json", metadata)

    timeout = int(config.get("timeout_seconds", 3600))
    usage_aborted = False
    try:
        with (
            (run_dir / "raw" / "events.jsonl").open("w", encoding="utf-8") as out,
            (run_dir / "raw" / "stderr.log").open("w", encoding="utf-8") as err,
        ):
            process = subprocess.Popen(
                command,
                stdin=subprocess.PIPE,
                stdout=out,
                stderr=err,
                text=True,
                cwd=workspace,
                env=model_environment,
            )
            assert process.stdin is not None
            process.stdin.write(prompt)
            process.stdin.close()
            deadline = time.monotonic() + timeout
            while process.poll() is None:
                remaining_timeout = deadline - time.monotonic()
                if remaining_timeout <= 0:
                    process.terminate()
                    raise subprocess.TimeoutExpired(command, timeout)
                try:
                    process.wait(timeout=min(USAGE_POLL_SECONDS, remaining_timeout))
                except subprocess.TimeoutExpired:
                    if usage_client is None:
                        continue
                    try:
                        remaining = usage_client.remaining_percent()
                    except UsageGuardError as exc:
                        usage_guard["status"] = "aborted_unavailable"
                        usage_guard["reason"] = str(exc)
                        usage_aborted = True
                    else:
                        usage_guard["last_remaining_percent"] = remaining
                        if remaining <= STOP_REMAINING_PERCENT:
                            usage_guard["status"] = "aborted_low_remaining"
                            usage_guard["reason"] = (
                                f"remaining quota {remaining:.1f}% reached the "
                                f"{STOP_REMAINING_PERCENT:.0f}% stop threshold"
                            )
                            usage_aborted = True
                    if usage_aborted:
                        # Claude Code treats SIGINT like a user interrupt and
                        # keeps the session transcript resumable.
                        if adapter == "claude-cli":
                            process.send_signal(signal.SIGINT)
                        else:
                            process.terminate()
                        try:
                            process.wait(timeout=30)
                        except subprocess.TimeoutExpired:
                            process.kill()
                            process.wait(timeout=5)
                        break
            completed_returncode = process.wait()
    finally:
        if usage_client is not None:
            usage_client.__exit__()

    if adapter == "claude-cli":
        summary = claude_result_summary(run_dir / "raw" / "events.jsonl")
        if summary is not None:
            final_message = summary.pop("result", None)
            if isinstance(final_message, str):
                (run_dir / "raw" / "final-message.md").write_text(
                    final_message, encoding="utf-8"
                )
            metadata["generator_result"] = summary
    if usage_aborted:
        usage_guard["resume"] = {
            "supported": session_id is not None,
            "session_id": session_id,
            "command": (
                f"python3 -m rulelab run {display_path(run_dir, REPO_ROOT)} --resume"
                if session_id is not None
                else None
            ),
        }
    metadata["status"] = (
        "aborted_usage_guard"
        if usage_aborted
        else "generated"
        if completed_returncode == 0
        else "failed"
    )
    metadata["finished_at"] = utc_now()
    metadata["generator_exit_code"] = completed_returncode
    write_run_metadata(run_dir / "run.json", metadata)
    return USAGE_GUARD_EXIT_CODE if usage_aborted else completed_returncode


def flatten(value: Any, prefix: str = "") -> dict[str, Any]:
    result: dict[str, Any] = {}
    if isinstance(value, dict):
        for key, child in value.items():
            path = f"{prefix}.{key}" if prefix else key
            result.update(flatten(child, path))
    elif isinstance(value, list):
        marker = f"{prefix}[]"
        if value:
            result.update(flatten(value[0], marker))
        else:
            result[marker] = []
    else:
        result[prefix] = value
    return result


def profile_diff(before: dict[str, Any], after: dict[str, Any]) -> dict[str, Any]:
    left = flatten(before)
    right = flatten(after)
    added = {key: right[key] for key in sorted(right.keys() - left.keys())}
    removed = {key: left[key] for key in sorted(left.keys() - right.keys())}
    changed = {
        key: {"before": left[key], "after": right[key]}
        for key in sorted(left.keys() & right.keys())
        if left[key] != right[key]
    }
    return {"added": added, "removed": removed, "changed": changed}


def file_record(path: Path, root: Path) -> dict[str, Any]:
    return {
        "path": display_path(path, root),
        "sha256": sha256(path),
        "bytes": path.stat().st_size,
    }


DOT_INPUT_PATH = re.compile(r"\binput(?:\.[A-Za-z_][A-Za-z0-9_]*)+")
BRACKET_INPUT_PATH = re.compile(r'''\binput\[(?:"([^"\\]+)"|'([^'\\]+)')\]''')
ASSIGNMENT = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s*:=\s*(.+)$")
COLLECTION_ALIAS = re.compile(
    r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s*:=\s*\[[^|]+\|\s*"
    r"[A-Za-z_][A-Za-z0-9_]*\s*:=\s*([A-Za-z_][A-Za-z0-9_]*)\[_\]"
)
ITERATOR_ASSIGNMENT = re.compile(
    r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s*:=\s*"
    r"([A-Za-z_][A-Za-z0-9_]*)\[_\]"
)
ITERATOR_ANYWHERE = re.compile(
    r"\b([A-Za-z_][A-Za-z0-9_]*)\s*:=\s*"
    r"([A-Za-z_][A-Za-z0-9_]*)\[_\]"
)


def _split_call_arguments(value: str) -> list[str]:
    parts: list[str] = []
    start = 0
    depth = 0
    quote: str | None = None
    escaped = False
    for index, character in enumerate(value):
        if quote:
            if escaped:
                escaped = False
            elif character == "\\":
                escaped = True
            elif character == quote:
                quote = None
        elif character in {'"', "'"}:
            quote = character
        elif character in "([{":
            depth += 1
        elif character in ")]}":
            depth -= 1
        elif character == "," and depth == 0:
            parts.append(value[start:index].strip())
            start = index + 1
    parts.append(value[start:].strip())
    return parts


def _balanced_call(text: str, start: int) -> str | None:
    opening = text.find("(", start)
    if opening < 0:
        return None
    depth = 0
    quote: str | None = None
    escaped = False
    for index in range(opening, len(text)):
        character = text[index]
        if quote:
            if escaped:
                escaped = False
            elif character == "\\":
                escaped = True
            elif character == quote:
                quote = None
            continue
        if character in {'"', "'"}:
            quote = character
        elif character == "(":
            depth += 1
        elif character == ")":
            depth -= 1
            if depth == 0:
                return text[start : index + 1]
    return None


def _rego_expression_path(expression: str, aliases: dict[str, str]) -> str | None:
    expression = expression.strip()
    if expression in aliases:
        return aliases[expression]
    indexed = re.fullmatch(r"([A-Za-z_][A-Za-z0-9_]*)\[_\]", expression)
    if indexed and indexed.group(1) in aliases:
        return aliases[indexed.group(1)] + "[]"
    dotted = re.fullmatch(
        r"([A-Za-z_][A-Za-z0-9_]*)(\.[A-Za-z_][A-Za-z0-9_]*)+",
        expression,
    )
    if dotted and dotted.group(1) in aliases:
        return aliases[dotted.group(1)] + expression[len(dotted.group(1)) :]
    if not expression.startswith("object.get("):
        return None
    call = _balanced_call(expression, 0)
    if call != expression:
        return None
    arguments = _split_call_arguments(call[len("object.get(") : -1])
    if len(arguments) < 2:
        return None
    base = _rego_expression_path(arguments[0], aliases)
    key_match = re.fullmatch(r'''["']([^"']+)["']''', arguments[1])
    if base is None or key_match is None:
        return None
    return f"{base}.{key_match.group(1)}"


def rego_input_paths(files: list[Path]) -> list[str]:
    paths: set[str] = set()
    for path in files:
        text = path.read_text(encoding="utf-8", errors="replace")
        paths.update(match.group(0) for match in DOT_INPUT_PATH.finditer(text))
        for match in BRACKET_INPUT_PATH.finditer(text):
            paths.add("input." + (match.group(1) or match.group(2)))
        aliases = {"input": "input"}
        for line in text.splitlines():
            if match := COLLECTION_ALIAS.match(line):
                if match.group(2) in aliases:
                    aliases[match.group(1)] = aliases[match.group(2)]
            elif match := ITERATOR_ASSIGNMENT.match(line):
                if match.group(2) in aliases:
                    aliases[match.group(1)] = aliases[match.group(2)] + "[]"
            elif match := ASSIGNMENT.match(line):
                if resolved := _rego_expression_path(match.group(2), aliases):
                    aliases[match.group(1)] = resolved

            for match in ITERATOR_ANYWHERE.finditer(line):
                if match.group(2) in aliases:
                    aliases[match.group(1)] = aliases[match.group(2)] + "[]"

            search_at = 0
            while (start := line.find("object.get(", search_at)) >= 0:
                call = _balanced_call(line, start)
                if call is None:
                    break
                if resolved := _rego_expression_path(call, aliases):
                    paths.add(resolved)
                search_at = start + len(call)

            for alias, base in aliases.items():
                pattern = re.compile(
                    rf"\b{re.escape(alias)}((?:\.[A-Za-z_][A-Za-z0-9_]*)+)"
                )
                for match in pattern.finditer(line):
                    paths.add(base + match.group(1))
        paths.discard("input")
    return sorted(paths)


def validate_rego_profile_paths(
    rego_files: list[Path], proposed_profile: dict[str, Any]
) -> tuple[list[str], list[str]]:
    input_paths = rego_input_paths(rego_files)
    available_profile_paths = known_profile_paths(proposed_profile)
    unknown_paths = sorted(
        path
        for path in input_paths
        if path.removeprefix("input.") not in available_profile_paths
    )
    return input_paths, unknown_paths


def finalize(args: argparse.Namespace) -> int:
    run_dir = Path(args.run_dir).resolve()
    workspace = run_dir / "workspace"
    metadata = read_json(run_dir / "run.json")
    if "contract_version" in metadata:
        RunArtifactV1.model_validate(metadata)
    baseline = read_json(run_dir / "baseline_profile.json")
    working = read_json(workspace / "canonical_farm_profile.json")
    direct_profile_diff = profile_diff(baseline, working)
    write_json(
        run_dir / "artifacts" / "direct-profile-diff.json", direct_profile_diff
    )

    grounded = validate_grounded_outputs(run_dir, metadata, baseline)
    rego_modules = sorted((workspace / "policy").rglob("*.rego"))
    rego_tests = sorted((workspace / "tests").rglob("*.rego"))
    data_files = sorted(
        path for path in (workspace / "data").rglob("*") if path.is_file()
    )
    rego_files = [*rego_modules, *rego_tests]
    input_paths, unknown_rego_input_paths = validate_rego_profile_paths(
        rego_files, grounded.proposed_profile
    )
    if unknown_rego_input_paths:
        grounded.errors["profile_application"].append(
            "Rego uses paths absent from proposed profile: "
            f"{unknown_rego_input_paths}"
        )
    write_json(
        run_dir / "artifacts" / "grounding-validation.json",
        {
            "contract_version": "grounding-validation-v1.0.0",
            "status": "passed" if grounded.valid else "failed",
            "errors": grounded.errors,
        },
    )
    write_json(
        run_dir / "artifacts" / "proposed-profile.json", grounded.proposed_profile
    )
    diff = profile_diff(baseline, grounded.proposed_profile)
    write_json(run_dir / "artifacts" / "profile-diff.json", diff)
    write_json(
        run_dir / "artifacts" / "input-paths.json",
        {
            "paths": input_paths,
            "count": len(input_paths),
            "unknown_profile_paths": unknown_rego_input_paths,
        },
    )
    metrics = {
        "rego_files": len(rego_files),
        "rego_lines": sum(
            len(path.read_text(encoding="utf-8", errors="replace").splitlines())
            for path in rego_files
        ),
        "input_paths": len(input_paths),
        "unknown_input_paths": len(unknown_rego_input_paths),
        "profile_paths_added": len(diff["added"]),
        "profile_paths_removed": len(diff["removed"]),
        "profile_paths_changed": len(diff["changed"]),
        "data_files": len(data_files),
        "data_bytes": sum(path.stat().st_size for path in data_files),
        "working_profile_unchanged": not any(direct_profile_diff.values()),
    }
    validation_exit_code: int | None = None
    if not args.skip_validation and rego_files:
        validation_result = run_dir / "artifacts" / "technical-validation.json"
        completed = subprocess.run(
            [
                sys.executable,
                str(OPA_RUNNER),
                "validate",
                "--workspace",
                str(workspace),
                *(
                    argument
                    for target in OPA_VALIDATION_TARGETS
                    for argument in ("--target", target)
                ),
                "--result-json",
                str(validation_result),
                "--pretty",
            ],
            capture_output=True,
            text=True,
            check=False,
        )
        validation_exit_code = completed.returncode
        (run_dir / "raw" / "validation.stdout.json").write_text(
            completed.stdout, encoding="utf-8"
        )
        (run_dir / "raw" / "validation.stderr.log").write_text(
            completed.stderr, encoding="utf-8"
        )
        metrics["technical_validation_exit_code"] = validation_exit_code

    required_files = {
        "structured_rules": workspace / "rules" / "rules.json",
        "source_references": workspace / "rules" / "citations.json",
        "profile_changes": workspace / "rules" / "profile_changes.json",
        "coverage_ledger": workspace / "rules" / "coverage.json",
        "data_inventory": workspace / "rules" / "data_inventory.json",
        "assumptions": workspace / "notes" / "assumptions.md",
        "raw_log": run_dir / "raw" / "events.jsonl",
    }
    if metadata.get("quality_gate_version") == "v2":
        required_files["execution_evidence"] = (
            workspace / "rules" / "execution_evidence.json"
        )
    missing_outputs = [
        name for name, path in required_files.items() if not path.is_file()
    ]
    if not rego_modules:
        missing_outputs.append("rego_modules")
    if not rego_tests:
        missing_outputs.append("rego_tests")
    structured_rule_count = len(grounded.rules.rules) if grounded.rules else None
    source_reference_count = (
        len(grounded.references.references) if grounded.references else None
    )
    profile_change_count = (
        len(grounded.profile_changes.changes) if grounded.profile_changes else None
    )
    coverage_item_count = (
        sum(len(source.items) for source in grounded.coverage.sources)
        if grounded.coverage
        else None
    )
    data_table_count = (
        sum(
            len(artifact.tables)
            for artifact in grounded.data_inventory.artifacts
        )
        if grounded.data_inventory
        else None
    )
    execution_evidence = grounded.execution_evidence
    executable_rule_count = (
        sum(item.status == "executable" for item in execution_evidence.rules)
        if execution_evidence
        else None
    )
    documented_rule_count = (
        sum(item.status == "documented_only" for item in execution_evidence.rules)
        if execution_evidence
        else None
    )
    unresolved_rule_count = (
        sum(item.status == "unresolved" for item in execution_evidence.rules)
        if execution_evidence
        else None
    )
    if structured_rule_count == 0:
        missing_outputs.append("structured_rules_empty")
    if source_reference_count == 0:
        missing_outputs.append("source_references_empty")
    if not grounded.valid:
        missing_outputs.append("grounding_validation_failed")
    if any(direct_profile_diff.values()):
        missing_outputs.append("working_profile_modified_directly")
    test_pattern = re.compile(r"(?m)^\s*(test_[A-Za-z0-9_]+)\s+(?:if|contains|:=|=)")
    generated_test_count = sum(
        len(test_pattern.findall(path.read_text(encoding="utf-8", errors="replace")))
        for path in rego_tests
    )
    metrics["structured_rule_count"] = structured_rule_count
    metrics["source_reference_count"] = source_reference_count
    metrics["profile_change_proposal_count"] = profile_change_count
    metrics["coverage_item_count"] = coverage_item_count
    metrics["data_table_count"] = data_table_count
    metrics["quality_gate_version"] = metadata.get("quality_gate_version", "v1")
    metrics["executable_rule_count"] = executable_rule_count
    metrics["documented_rule_count"] = documented_rule_count
    metrics["unresolved_rule_count"] = unresolved_rule_count
    metrics["grounding_valid"] = grounded.valid
    metrics["contract_errors"] = grounded.errors
    metrics["generated_test_count"] = generated_test_count
    metrics["required_outputs_missing"] = sorted(missing_outputs)
    metrics["conform_profile_unchanged"] = (
        metrics["working_profile_unchanged"]
        and (profile_change_count or 0) == 0
    )

    inventory_created = False
    if not missing_outputs:
        inventory = {
            "contract_version": "artifact-inventory-v2.0.0",
            "run_id": metadata["run_id"],
            "source_files": [
                file_record(path, run_dir)
                for path in sorted((workspace / "sources").iterdir())
                if path.is_file() and path.name != "manifest.json"
            ],
            "baseline_profile": file_record(run_dir / "baseline_profile.json", run_dir),
            "working_profile": file_record(
                workspace / "canonical_farm_profile.json", run_dir
            ),
            "proposed_profile": file_record(
                run_dir / "artifacts" / "proposed-profile.json", run_dir
            ),
            "direct_profile_diff": file_record(
                run_dir / "artifacts" / "direct-profile-diff.json", run_dir
            ),
            "profile_diff": file_record(
                run_dir / "artifacts" / "profile-diff.json", run_dir
            ),
            "grounding_validation": file_record(
                run_dir / "artifacts" / "grounding-validation.json", run_dir
            ),
            "structured_rules": file_record(
                required_files["structured_rules"], run_dir
            ),
            "source_references": file_record(
                required_files["source_references"], run_dir
            ),
            "profile_changes": file_record(required_files["profile_changes"], run_dir),
            "coverage_ledger": file_record(required_files["coverage_ledger"], run_dir),
            "data_inventory": file_record(required_files["data_inventory"], run_dir),
            "rego_modules": [file_record(path, run_dir) for path in rego_modules],
            "data_files": [file_record(path, run_dir) for path in data_files],
            "rego_tests": [file_record(path, run_dir) for path in rego_tests],
            "assumptions": file_record(required_files["assumptions"], run_dir),
            "raw_log": file_record(required_files["raw_log"], run_dir),
        }
        write_json(run_dir / "artifacts" / "inventory.json", inventory)
        inventory_created = True
    metrics["inventory_created"] = inventory_created
    write_json(run_dir / "artifacts" / "metrics.json", metrics)

    conform_violation = (
        metadata["mode"] == "conform"
        and not metrics["conform_profile_unchanged"]
    )
    validation_failed = validation_exit_code not in {None, 0}
    finalization_failed = (
        bool(missing_outputs) or conform_violation or validation_failed
    )
    metadata["status"] = "failed" if finalization_failed else "finalized"
    metadata["finalized_at"] = utc_now()
    metadata["metrics"] = metrics
    write_run_metadata(run_dir / "run.json", metadata)
    print(json.dumps(metrics, ensure_ascii=False, indent=2))
    return 1 if finalization_failed else 0


def compare_runs(args: argparse.Namespace) -> int:
    rows: list[dict[str, Any]] = []
    for raw_path in args.run_dirs:
        run_dir = Path(raw_path).resolve()
        metadata = read_json(run_dir / "run.json")
        metrics = metadata.get("metrics", {})
        validation_path = run_dir / "artifacts" / "technical-validation.json"
        validation_status = None
        if validation_path.is_file():
            validation_status = read_json(validation_path).get("status")
        model = metadata.get("model", {})
        rows.append(
            {
                "run_id": metadata.get("run_id"),
                "measure": metadata.get("measure"),
                "mode": metadata.get("mode"),
                "provider": model.get("provider"),
                "model": model.get("model"),
                "reasoning_effort": model.get("reasoning_effort"),
                "status": metadata.get("status"),
                "opa_status": validation_status,
                "structured_rule_count": metrics.get("structured_rule_count"),
                "source_reference_count": metrics.get("source_reference_count"),
                "generated_test_count": metrics.get("generated_test_count"),
                "rego_files": metrics.get("rego_files"),
                "rego_lines": metrics.get("rego_lines"),
                "data_files": metrics.get("data_files"),
                "data_bytes": metrics.get("data_bytes"),
                "input_paths": metrics.get("input_paths"),
                "unknown_input_paths": metrics.get("unknown_input_paths"),
                "profile_paths_added": metrics.get("profile_paths_added"),
                "profile_paths_removed": metrics.get("profile_paths_removed"),
                "profile_paths_changed": metrics.get("profile_paths_changed"),
                "profile_change_proposal_count": metrics.get(
                    "profile_change_proposal_count"
                ),
                "coverage_item_count": metrics.get("coverage_item_count"),
                "data_table_count": metrics.get("data_table_count"),
                "grounding_valid": metrics.get("grounding_valid"),
                "working_profile_unchanged": metrics.get(
                    "working_profile_unchanged"
                ),
            }
        )
    result = {"contract_version": "run-comparison-v1.0.0", "runs": rows}
    rendered = json.dumps(result, ensure_ascii=False, indent=2) + "\n"
    if args.output:
        output = Path(args.output).resolve()
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(rendered, encoding="utf-8")
    print(rendered, end="")
    return 0


def export_schemas(args: argparse.Namespace) -> int:
    output = Path(args.output).resolve()
    for path in export_generator_schemas(output):
        print(path)
    return 0


def verify_grounding(args: argparse.Namespace) -> int:
    """Run the deterministic grounding gates without modifying the run."""
    run_dir = Path(args.run_dir).resolve()
    metadata = read_json(run_dir / "run.json")
    baseline = read_json(run_dir / "baseline_profile.json")
    grounded = validate_grounded_outputs(run_dir, metadata, baseline)
    workspace = run_dir / "workspace"
    rego_files = sorted((workspace / "policy").rglob("*.rego")) + sorted(
        (workspace / "tests").rglob("*.rego")
    )
    _, unknown_rego_input_paths = validate_rego_profile_paths(
        rego_files, grounded.proposed_profile
    )
    if unknown_rego_input_paths:
        grounded.errors["profile_application"].append(
            "Rego uses paths absent from proposed profile: "
            f"{unknown_rego_input_paths}"
        )
    result = {
        "contract_version": "grounding-validation-v1.0.0",
        "status": "passed" if grounded.valid else "failed",
        "errors": grounded.errors,
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if grounded.valid else 1


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="rulelab")
    subparsers = parser.add_subparsers(dest="command", required=True)

    prepare_parser = subparsers.add_parser("prepare")
    prepare_parser.add_argument("--measure", required=True)
    prepare_parser.add_argument("--model", required=True)
    prepare_parser.add_argument(
        "--mode", choices=("discover", "conform"), default="discover"
    )
    prepare_parser.add_argument("--run-id")
    prepare_parser.add_argument(
        "--quality-gate",
        choices=("v1", "v2"),
        default="v1",
        help="v2 additionally requires rules/execution_evidence.json",
    )
    prepare_parser.add_argument("--profile", default=str(DEFAULT_PROFILE))
    prepare_parser.add_argument("--sources", default=str(DEFAULT_SOURCES))
    prepare_parser.add_argument("--all-sources", action="store_true")
    prepare_parser.add_argument(
        "--skip-pdf-text",
        action="store_true",
        help="Do not create page-marked text companions for source PDFs",
    )
    prepare_parser.set_defaults(func=prepare)

    run_parser = subparsers.add_parser("run")
    run_parser.add_argument("run_dir")
    run_parser.add_argument("--dry-run", action="store_true")
    run_parser.add_argument(
        "--resume",
        action="store_true",
        help="Continue the recorded generator session (claude-cli adapter only)",
    )
    run_parser.set_defaults(func=run_agent)

    finalize_parser = subparsers.add_parser("finalize")
    finalize_parser.add_argument("run_dir")
    finalize_parser.add_argument("--skip-validation", action="store_true")
    finalize_parser.set_defaults(func=finalize)

    verify_parser = subparsers.add_parser(
        "verify-grounding",
        help=(
            "Validate contracts, evidence, coverage, data, and profile proposals "
            "read-only"
        ),
    )
    verify_parser.add_argument("run_dir")
    verify_parser.set_defaults(func=verify_grounding)

    compare_parser = subparsers.add_parser("compare")
    compare_parser.add_argument("run_dirs", nargs="+")
    compare_parser.add_argument("--output")
    compare_parser.set_defaults(func=compare_runs)

    schemas_parser = subparsers.add_parser("export-schemas")
    schemas_parser.add_argument("--output", default=str(REPO_ROOT / "contracts"))
    schemas_parser.set_defaults(func=export_schemas)
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        return int(args.func(args))
    except (FileNotFoundError, FileExistsError, ValueError, KeyError) as exc:
        parser.error(str(exc))
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
