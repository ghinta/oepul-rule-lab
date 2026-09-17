from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any

from .contracts import GENERATOR_CONTRACT_MODELS, export_generator_schemas
from .grounding import known_profile_paths, validate_grounded_outputs


REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_PROFILE = REPO_ROOT / "profiles" / "canonical_farm_profile.json"
DEFAULT_SOURCES = REPO_ROOT / "sources" / "oepul"
OPA_RUNNER = REPO_ROOT / "runner" / "validation" / "opa_validate.py"
GENERATOR_CONTRACTS = tuple(GENERATOR_CONTRACT_MODELS)


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


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


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


def render_prompt(template: str, values: dict[str, str]) -> str:
    for key, value in values.items():
        template = template.replace("{{" + key + "}}", value)
    return template


def prepare(args: argparse.Namespace) -> int:
    model_path = Path(args.model).resolve()
    model_config = read_json(model_path)
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
        version_file = OPA_RUNNER.parent / "opa-version.txt"
        if version_file.is_file():
            shutil.copy2(version_file, workspace / "tools" / "opa-version.txt")

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
    prompt = render_prompt(
        prompt_template,
        {
            "MEASURE_ID": args.measure,
            "MODE": args.mode,
            "RUN_ID": run_id,
            "SOURCE_LIST": "\n".join(prompt_source_lines),
        },
    )
    (run_dir / "prompt.md").write_text(prompt, encoding="utf-8")

    metadata = {
        "contract_version": "1.0",
        "run_id": run_id,
        "created_at": utc_now(),
        "status": "prepared",
        "mode": args.mode,
        "measure": args.measure,
        "model": model_config,
        "profile": {
            "path": display_path(profile_path, REPO_ROOT),
            "sha256": sha256(profile_path),
        },
        "sources": source_records,
    }
    write_json(run_dir / "run.json", metadata)
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
    config = read_json(run_dir / "model.json")
    adapter = config.get("adapter", "codex-cli")
    if adapter == "codex-cli":
        command = codex_command(config, run_dir)
    elif adapter == "external-command":
        command = external_command(config, run_dir)
    else:
        raise ValueError(f"Unsupported adapter: {adapter}")

    if args.dry_run:
        print(json.dumps(command, ensure_ascii=False, indent=2))
        return 0

    prompt = (run_dir / "prompt.md").read_text(encoding="utf-8")
    generation_attempt = prepare_raw_attempt(run_dir / "raw")
    metadata["status"] = "running"
    metadata["started_at"] = utc_now()
    metadata["invocation"] = command
    metadata["generation_attempt"] = generation_attempt
    write_json(run_dir / "run.json", metadata)

    timeout = int(config.get("timeout_seconds", 3600))
    with (run_dir / "raw" / "events.jsonl").open("w", encoding="utf-8") as out:
        completed = subprocess.run(
            command,
            input=prompt,
            text=True,
            stdout=out,
            stderr=subprocess.PIPE,
            cwd=run_dir / "workspace",
            timeout=timeout,
            check=False,
            env=os.environ.copy(),
        )
    (run_dir / "raw" / "stderr.log").write_text(
        completed.stderr or "", encoding="utf-8"
    )
    metadata["status"] = "generated" if completed.returncode == 0 else "failed"
    metadata["finished_at"] = utc_now()
    metadata["generator_exit_code"] = completed.returncode
    write_json(run_dir / "run.json", metadata)
    return completed.returncode


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
                "--target",
                "policy",
                "--target",
                "tests",
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
    write_json(run_dir / "run.json", metadata)
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
