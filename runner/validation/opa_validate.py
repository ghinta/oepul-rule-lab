#!/usr/bin/env python3
"""Technical OPA validation runner for generated Rego workspaces.

The runner deliberately checks only executable quality: formatting, strict
compilation, and OPA tests. It does not implement semantic or study gates.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Sequence


RESULT_SCHEMA_VERSION = "oepul-rule-lab-opa-validation-v1"
RUNNER_DIR = Path(__file__).resolve().parent
DEFAULT_VERSION = (RUNNER_DIR / "opa-version.txt").read_text(encoding="utf-8").strip()
MAX_CAPTURE_CHARS = 20_000


class RunnerError(RuntimeError):
    """Raised for runner configuration and workspace errors."""


@dataclass(frozen=True)
class Execution:
    argv: list[str]
    returncode: int
    stdout: str
    stderr: str
    duration_ms: int


def capture(text: str) -> tuple[str, bool]:
    if len(text) <= MAX_CAPTURE_CHARS:
        return text, False
    return text[:MAX_CAPTURE_CHARS], True


class OpaRuntime:
    def __init__(
        self,
        *,
        kind: str,
        workspace: Path,
        version: str,
        opa_bin: str | None,
        image: str,
        timeout_seconds: float,
    ) -> None:
        self.kind = kind
        self.workspace = workspace
        self.version = version
        self.opa_bin = opa_bin
        self.image = image
        self.timeout_seconds = timeout_seconds

    def command(self, args: Sequence[str]) -> list[str]:
        if self.kind == "local":
            assert self.opa_bin is not None
            return [self.opa_bin, *args]
        return [
            "docker",
            "run",
            "--rm",
            "-v",
            f"{self.workspace}:/workspace:ro",
            "-w",
            "/workspace",
            self.image,
            *args,
        ]

    def execute(self, args: Sequence[str]) -> Execution:
        argv = self.command(args)
        started = time.monotonic()
        try:
            completed = subprocess.run(
                argv,
                cwd=self.workspace,
                capture_output=True,
                text=True,
                encoding="utf-8",
                errors="replace",
                timeout=self.timeout_seconds,
                check=False,
            )
        except OSError as exc:
            raise RunnerError(f"runtime executable not found: {argv[0]}") from exc
        except subprocess.TimeoutExpired as exc:
            raise RunnerError(
                f"OPA command exceeded {self.timeout_seconds:g}s: {' '.join(argv)}"
            ) from exc
        duration_ms = round((time.monotonic() - started) * 1000)
        return Execution(
            argv=argv,
            returncode=completed.returncode,
            stdout=completed.stdout,
            stderr=completed.stderr,
            duration_ms=duration_ms,
        )


def resolve_runtime(args: argparse.Namespace, workspace: Path) -> OpaRuntime:
    requested = args.runtime
    configured_bin = args.opa_bin or os.environ.get("OPA_BIN")
    if requested == "auto":
        if configured_bin:
            kind = "local"
        elif (workspace / "tools" / "opa").is_file():
            kind = "local"
            configured_bin = str(workspace / "tools" / "opa")
        elif shutil.which("opa"):
            kind = "local"
            configured_bin = shutil.which("opa")
        else:
            kind = "docker"
    else:
        kind = requested

    if kind == "local":
        configured_bin = configured_bin or shutil.which("opa")
        if not configured_bin:
            raise RunnerError("local runtime selected, but no OPA binary was found")
        resolved_bin = shutil.which(configured_bin) or configured_bin
        if not Path(resolved_bin).is_file():
            raise RunnerError(f"OPA binary does not exist: {resolved_bin}")
        configured_bin = str(Path(resolved_bin).resolve())

    return OpaRuntime(
        kind=kind,
        workspace=workspace,
        version=args.opa_version,
        opa_bin=configured_bin,
        image=args.opa_image,
        timeout_seconds=args.timeout,
    )


def resolve_targets(workspace: Path, raw_targets: Sequence[str]) -> list[str]:
    targets: list[str] = []
    for raw in raw_targets:
        candidate = (workspace / raw).resolve()
        try:
            relative = candidate.relative_to(workspace)
        except ValueError as exc:
            raise RunnerError(f"target escapes workspace: {raw}") from exc
        if not candidate.exists():
            raise RunnerError(f"target does not exist: {raw}")
        normalized = relative.as_posix() or "."
        if normalized not in targets:
            targets.append(normalized)
    return targets


def rego_files(workspace: Path, targets: Sequence[str]) -> list[Path]:
    files: set[Path] = set()
    for target in targets:
        path = workspace if target == "." else workspace / target
        if path.is_file() and path.suffix == ".rego":
            candidates = [path]
        elif path.is_dir():
            candidates = [item for item in path.rglob("*.rego") if item.is_file()]
        else:
            candidates = []
        for candidate in candidates:
            resolved = candidate.resolve()
            try:
                resolved.relative_to(workspace)
            except ValueError as exc:
                raise RunnerError(
                    f"Rego file resolves outside workspace: {candidate.relative_to(workspace)}"
                ) from exc
            files.add(resolved)
    if not files:
        raise RunnerError("workspace targets contain no .rego files")
    return sorted(files)


def execution_json(execution: Execution) -> dict[str, Any]:
    stdout, stdout_truncated = capture(execution.stdout)
    stderr, stderr_truncated = capture(execution.stderr)
    return {
        "argv": execution.argv,
        "returncode": execution.returncode,
        "duration_ms": execution.duration_ms,
        "stdout": stdout,
        "stderr": stderr,
        "stdout_truncated": stdout_truncated,
        "stderr_truncated": stderr_truncated,
    }


def verify_version(runtime: OpaRuntime) -> dict[str, Any]:
    execution = runtime.execute(["version"])
    details = execution_json(execution)
    match = re.search(r"^Version:\s*(\S+)", execution.stdout, flags=re.MULTILINE)
    actual = match.group(1) if match else None
    if execution.returncode != 0 or actual is None:
        status = "error"
    elif actual != runtime.version:
        status = "failed"
    else:
        status = "passed"
    return {
        "status": status,
        "expected": runtime.version,
        "actual": actual,
        "execution": details,
    }


def run_format(
    runtime: OpaRuntime,
    workspace: Path,
    files: Sequence[Path],
    *,
    write: bool,
) -> dict[str, Any]:
    started = time.monotonic()
    executions: list[dict[str, Any]] = []
    unformatted: list[str] = []
    formatted: list[str] = []
    command_failed = False

    for path in files:
        relative = path.relative_to(workspace).as_posix()
        execution = runtime.execute(["fmt", relative])
        executions.append(execution_json(execution))
        if execution.returncode != 0:
            command_failed = True
            continue
        current = path.read_text(encoding="utf-8")
        if execution.stdout != current:
            unformatted.append(relative)
            if write:
                path.write_text(execution.stdout, encoding="utf-8")
                formatted.append(relative)

    if command_failed:
        status = "error"
    elif unformatted and not write:
        status = "failed"
    else:
        status = "passed"
    return {
        "status": status,
        "duration_ms": round((time.monotonic() - started) * 1000),
        "checked_files": [path.relative_to(workspace).as_posix() for path in files],
        "unformatted_files": unformatted,
        "formatted_files": formatted,
        "write": write,
        "executions": executions,
    }


def run_opa_stage(runtime: OpaRuntime, name: str, opa_args: Sequence[str]) -> dict[str, Any]:
    execution = runtime.execute(opa_args)
    return {
        "status": "passed" if execution.returncode == 0 else "failed",
        "name": name,
        "execution": execution_json(execution),
    }


def atomic_write_json(path: Path, payload: dict[str, Any], *, pretty: bool) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    text = json.dumps(payload, ensure_ascii=False, indent=2 if pretty else None, sort_keys=True)
    text += "\n"
    with tempfile.NamedTemporaryFile(
        mode="w", encoding="utf-8", dir=path.parent, delete=False
    ) as handle:
        handle.write(text)
        temporary = Path(handle.name)
    os.replace(temporary, path)


def aggregate_status(stages: dict[str, dict[str, Any]]) -> str:
    statuses = {stage["status"] for stage in stages.values()}
    if "error" in statuses:
        return "error"
    if "failed" in statuses:
        return "failed"
    return "passed"


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Run technical OPA formatting, strict compilation, and tests."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    for command in ("validate", "fmt", "check", "test"):
        child = subparsers.add_parser(command)
        child.add_argument("--workspace", default=".", help="Run workspace root")
        child.add_argument(
            "--target",
            action="append",
            dest="targets",
            help="Workspace-relative file or directory; repeatable (default: .)",
        )
        child.add_argument(
            "--runtime",
            choices=("auto", "local", "docker"),
            default=os.environ.get("OPA_RUNTIME", "auto"),
        )
        child.add_argument("--opa-bin", default=None, help="Local OPA executable")
        child.add_argument(
            "--opa-version",
            default=os.environ.get("OPA_VERSION", DEFAULT_VERSION),
            help=f"Expected OPA version (default pin: {DEFAULT_VERSION})",
        )
        child.add_argument(
            "--opa-image",
            default=os.environ.get("OPA_IMAGE"),
            help="Docker image override (default: openpolicyagent/opa:<version>-static)",
        )
        child.add_argument("--timeout", type=float, default=120.0)
        child.add_argument("--result-json", help="Optional machine-readable result path")
        child.add_argument("--pretty", action="store_true", help="Pretty-print JSON")
        child.add_argument(
            "--write",
            action="store_true",
            help="For fmt/validate, replace unformatted Rego with OPA output",
        )
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    if args.write and args.command not in {"fmt", "validate"}:
        parser.error("--write is available only for fmt and validate")
    if args.timeout <= 0:
        parser.error("--timeout must be positive")

    workspace = Path(args.workspace).expanduser().resolve()
    if args.opa_image is None:
        args.opa_image = f"openpolicyagent/opa:{args.opa_version}-static"

    started = time.monotonic()
    stages: dict[str, dict[str, Any]] = {}
    result: dict[str, Any]
    try:
        if not workspace.is_dir():
            raise RunnerError(f"workspace is not a directory: {workspace}")
        targets = resolve_targets(workspace, args.targets or ["."])
        files = rego_files(workspace, targets)
        runtime = resolve_runtime(args, workspace)

        stages["version"] = verify_version(runtime)
        if stages["version"]["status"] == "passed":
            if args.command in {"validate", "fmt"}:
                stages["fmt"] = run_format(runtime, workspace, files, write=args.write)
            if args.command in {"validate", "check"}:
                stages["check"] = run_opa_stage(
                    runtime, "check", ["check", "--strict", *targets]
                )
            if args.command in {"validate", "test"}:
                stages["test"] = run_opa_stage(runtime, "test", ["test", *targets])

        result = {
            "schema_version": RESULT_SCHEMA_VERSION,
            "status": aggregate_status(stages),
            "command": args.command,
            "workspace": str(workspace),
            "targets": targets,
            "rego_files": [path.relative_to(workspace).as_posix() for path in files],
            "opa": {
                "runtime": runtime.kind,
                "expected_version": runtime.version,
                "image": runtime.image if runtime.kind == "docker" else None,
                "binary": runtime.opa_bin if runtime.kind == "local" else None,
            },
            "stages": stages,
            "duration_ms": round((time.monotonic() - started) * 1000),
        }
    except RunnerError as exc:
        result = {
            "schema_version": RESULT_SCHEMA_VERSION,
            "status": "error",
            "command": args.command,
            "workspace": str(workspace),
            "targets": args.targets or ["."],
            "rego_files": [],
            "opa": {
                "runtime": args.runtime,
                "expected_version": args.opa_version,
                "image": args.opa_image,
                "binary": args.opa_bin,
            },
            "stages": stages,
            "error": str(exc),
            "duration_ms": round((time.monotonic() - started) * 1000),
        }

    exit_code = {"passed": 0, "failed": 1, "error": 2}[result["status"]]
    result["exit_code"] = exit_code
    if args.result_json:
        try:
            atomic_write_json(Path(args.result_json).expanduser().resolve(), result, pretty=True)
        except OSError as exc:
            result["status"] = "error"
            result["exit_code"] = 2
            result["error"] = f"could not write result JSON: {exc}"
    print(json.dumps(result, ensure_ascii=False, indent=2 if args.pretty else None, sort_keys=True))
    return result["exit_code"]


if __name__ == "__main__":
    sys.exit(main())
