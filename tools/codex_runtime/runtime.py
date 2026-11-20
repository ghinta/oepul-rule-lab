#!/usr/bin/env python3
"""Dedicated Codex home and sandbox for the authorized Astra Rule Lab runs."""

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import platform
import select
import shlex
import shutil
import subprocess
import sys
import time

DIRECTORY = Path(__file__).resolve().parent
ROOT = DIRECTORY.parents[1]
STATE = ROOT / ".rulelab-cache/codex-runtime"
IMAGE = "oepul-rulelab-codex:0.171.0"
VOLUME = "oepul-rulelab-codex-home-v1"
LABEL = "org.oepul.rulelab.runtime"
VERSION = "0.171.0"
DOCKER = ["docker", "--host=unix:///var/run/docker.sock"]


def docker_env():
    env = os.environ.copy()
    for key in ("DOCKER_HOST", "DOCKER_CONTEXT", "DOCKER_TLS", "DOCKER_TLS_VERIFY", "DOCKER_CERT_PATH"):
        env.pop(key, None)
    env["BUILDX_CONFIG"] = str(STATE / "buildx")
    return env


def call(arguments, **kwargs):
    return subprocess.run(arguments, env=docker_env(), check=True, **kwargs)


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def configuration():
    config = json.loads((STATE / "config.json").read_text())
    actual = call(DOCKER + ["image", "inspect", IMAGE, "--format", "{{.Id}}"],
                  capture_output=True, text=True).stdout.strip()
    if actual != config["image_id"] or digest(DIRECTORY / "seccomp.json") != config["seccomp_sha256"]:
        raise ValueError("Runtime image or seccomp configuration changed; rebuild and repeat preflight")
    return config


def build(runs_root):
    if platform.system() != "Linux" or os.getuid() != 1000:
        raise ValueError("This runner currently supports a Linux Docker host and UID 1000")
    runs_root = runs_root.resolve(strict=True)
    STATE.mkdir(parents=True, exist_ok=True)
    package = STATE / "package"
    package.mkdir(exist_ok=True)
    for name in ("package.json", "package-lock.json"):
        shutil.copy2(DIRECTORY / name, package / name)
    call(["npm", "--cache", str(STATE / "npm-cache"), "ci", "--prefix", str(package),
          "--ignore-scripts", "--no-audit", "--no-fund"])
    architecture = {"x86_64": ("x64", "x86_64"), "aarch64": ("arm64", "aarch64")}.get(platform.machine())
    if architecture is None:
        raise ValueError("Unsupported Codex architecture")
    npm_arch, target_arch = architecture
    vendor = package / f"node_modules/@openai/codex-linux-{npm_arch}/vendor/{target_arch}-unknown-linux-musl"
    context = STATE / "build-context"
    context.mkdir(exist_ok=True)
    shutil.copy2(DIRECTORY / "Dockerfile", context / "Dockerfile")
    for name in ("bin", "codex-path"):
        shutil.copytree(vendor / name, context / "vendor" / name, dirs_exist_ok=True)
    resources = context / "vendor/codex-resources"
    resources.mkdir(parents=True, exist_ok=True)
    shutil.copy2(vendor / "codex-resources/bwrap", resources / "bwrap")
    shutil.copy2(vendor / "codex-package.json", context / "vendor/codex-package.json")
    call(DOCKER + ["build", "--network=none", "-t", IMAGE, str(context)])
    existing = subprocess.run(DOCKER + ["volume", "inspect", VOLUME], env=docker_env(),
                              capture_output=True, text=True)
    if existing.returncode == 0:
        labels = json.loads(existing.stdout)[0].get("Labels") or {}
        if labels.get(LABEL) != "v1":
            raise ValueError("Refusing to reuse a volume not owned by this runner")
    else:
        call(DOCKER + ["volume", "create", "--label", LABEL + "=v1", VOLUME])
    image_id = call(DOCKER + ["image", "inspect", IMAGE, "--format", "{{.Id}}"],
                    capture_output=True, text=True).stdout.strip()
    config = {"codex_version": VERSION, "image_id": image_id, "runs_root": str(runs_root),
              "seccomp_sha256": digest(DIRECTORY / "seccomp.json"),
              "package_lock_sha256": digest(DIRECTORY / "package-lock.json")}
    (STATE / "config.json").write_text(json.dumps(config, indent=2) + "\n")
    binary = STATE / "bin/codex"
    binary.parent.mkdir(exist_ok=True)
    binary.write_text("#!/bin/sh\nexec " + shlex.quote(sys.executable) + " "
                      + shlex.quote(str(Path(__file__).resolve())) + ' codex "$@"\n')
    binary.chmod(0o755)
    print("Runner built. Next: preflight, then login --device-auth.")


def container(config, *, offline=False):
    args = DOCKER + ["run", "--rm", "--init", "-i", "--label", LABEL + "=v1", "--read-only",
                    "--cap-drop=ALL", "--security-opt=no-new-privileges",
                    "--security-opt", "seccomp=" + str(DIRECTORY / "seccomp.json"),
                    "--pids-limit=512", "--memory=8g", "--tmpfs", "/tmp:rw,nosuid,nodev,size=512m",
                    "--mount", "type=volume,src=" + VOLUME + ",dst=/home/rulelab"]
    if offline:
        args += ["--network=none"]
    # Keep Docker's configured proxy. Its address can differ from the executor's.
    ca = Path("/etc/ssl/certs/ca-certificates.crt")
    if os.environ.get("CODEX_PROXY_CERT") and ca.is_file():
        args += ["--mount", f"type=bind,src={ca},dst={ca},readonly"]
    return args


def bind_run(arguments, config):
    if "--cd" not in arguments or "--output-last-message" not in arguments:
        raise ValueError("Expected the existing Rule Lab invocation with --cd and --output-last-message")
    workspace = Path(arguments[arguments.index("--cd") + 1]).absolute()
    root = Path(config["runs_root"])
    if workspace.is_symlink() or workspace.resolve() != workspace or workspace.name != "workspace":
        raise ValueError("Run workspace must be an explicit directory without symlinks")
    run = workspace.parent
    if run.parent != root or not workspace.is_dir():
        raise ValueError("Workspace is outside the configured runs directory")
    metadata = json.loads((run / "run.json").read_text())
    model = json.loads((run / "model.json").read_text())
    if metadata["run_id"] != run.name or model["adapter"] != "codex-cli" or model["model"] != "gpt-6.2-astra":
        raise ValueError("Only the prepared Astra 6.2 runs are authorized for this runner")
    if "--model" not in arguments or arguments[arguments.index("--model") + 1] != model["model"]:
        raise ValueError("Requested model differs from the prepared run")
    output = Path(arguments[arguments.index("--output-last-message") + 1]).absolute()
    if output != run / "raw/final-message.md" or output.is_symlink() or output.resolve() != output:
        raise ValueError("Unexpected final-message destination")
    if "--sandbox" not in arguments or arguments[arguments.index("--sandbox") + 1] != "workspace-write":
        raise ValueError("The workspace-write sandbox must remain enabled")
    if any(value.startswith("--dangerously") for value in arguments):
        raise ValueError("Sandbox and approval bypass flags are not supported")
    mounts = ["--mount", f"type=bind,src={run},dst={run}", "--workdir", str(workspace)]
    for name in ("sources", "canonical_farm_profile.json", "AGENTS.md", "contracts", "tools"):
        path = workspace / name
        if path.is_symlink() or not path.exists():
            raise ValueError("Missing or symlinked fixed workspace input")
        mounts += ["--mount", f"type=bind,src={path},dst={path},readonly"]
    mounts += ["--env", "OPA_RUNTIME=local", "--env", f"OPA_BIN={workspace}/tools/opa",
               "--env", f"RULELAB_OPA_BIN={workspace}/tools/opa",
               "--env", f"PATH={workspace}/tools:/opt/codex/bin:/opt/codex/codex-path:/usr/local/bin:/usr/bin:/bin"]
    proof = {"classification": "runner_environment", "image_id": config["image_id"],
             "codex_version": VERSION, "seccomp_sha256": config["seccomp_sha256"],
             "isolated_user_home": True, "native_sandbox": "workspace-write",
             "local_opa": True, "docker_socket_exposed_to_generator": False,
             "fixed_inputs_read_only": True, "git_repository_check": "skipped; only this run is mounted"}
    extra = ["--skip-git-repo-check", "-c", 'web_search="disabled"']
    proof["web_search"] = "disabled"
    (run / "raw/runner-environment.json").write_text(json.dumps(proof, indent=2) + "\n")
    return mounts, [*arguments[:-1], *extra, "-"] if arguments[-1] == "-" else [*arguments, *extra]


def codex(arguments):
    config = configuration()
    if not arguments or arguments[0] not in ("app-server", "login", "--version", "exec"):
        raise ValueError("Supported commands: app-server, login, --version and Rule Lab exec")
    mounts = []
    if arguments[0] == "exec":
        mounts, arguments = bind_run(arguments, config)
    args = container(config) + mounts + [config["image_id"], *arguments]
    os.execvpe(args[0], args, docker_env())


def rpc(config, requests, *, offline=False):
    p = subprocess.Popen(container(config, offline=offline) + [config["image_id"], "app-server"],
                         env=docker_env(), stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                         stderr=subprocess.DEVNULL, bufsize=0)
    results = {}
    try:
        messages = [{"id": 1, "method": "initialize", "params": {
            "clientInfo": {"name": "oepul-rule-lab-runtime", "version": "1.0"}}},
                    {"method": "initialized", "params": {}}]
        messages += [{"id": i, "method": method, "params": params}
                     for i, (method, params) in enumerate(requests, 2)]
        for message in messages:
            p.stdin.write((json.dumps(message) + "\n").encode())
        p.stdin.flush()
        deadline = time.monotonic() + 30
        pending = b""
        while len(results) < len(requests) + 1 and time.monotonic() < deadline:
            ready, _, _ = select.select([p.stdout], [], [], max(0, deadline - time.monotonic()))
            if not ready:
                break
            chunk = os.read(p.stdout.fileno(), 65536)
            if not chunk:
                break
            pending += chunk
            while b"\n" in pending:
                line, pending = pending.split(b"\n", 1)
                row = json.loads(line)
                if "id" in row:
                    results[row["id"]] = row
    finally:
        p.stdin.close()
        try:
            p.wait(timeout=5)
        except subprocess.TimeoutExpired:
            p.terminate()
            try:
                p.wait(timeout=5)
            except subprocess.TimeoutExpired:
                p.kill()
                p.wait()
        p.stdout.close()
    if 1 not in results or "result" not in results[1]:
        raise ValueError("Codex App Server did not initialize")
    return results


SMOKE = """from pathlib import Path
import errno, socket
Path('inside').write_text('ok')
blocked = False
try: Path('/home/rulelab/outside-probe').write_text('unexpected')
except OSError as error: blocked = error.errno in (errno.EACCES, errno.EPERM, errno.EROFS)
assert blocked, 'outside-workspace write must fail'
blocked = False
try: socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except OSError as error: blocked = error.errno in (errno.EACCES, errno.EPERM)
assert blocked, 'generator network sockets must fail'
print('PASS: workspace writes allowed; outside writes and network sockets denied')
"""


def preflight():
    config = configuration()
    work = STATE / "smoke-workspace"
    work.mkdir(exist_ok=True)
    command = container(config, offline=True) + ["--mount", f"type=bind,src={work},dst=/run/workspace",
                                               config["image_id"], "sandbox", "-c",
                                               'sandbox_mode="workspace-write"', "--", "python3", "-c", SMOKE]
    call(command)
    response = rpc(config, [("account/read", {})], offline=True)
    if 2 not in response or "result" not in response[2]:
        raise ValueError("Codex account status could not be read")
    result = {"app_server": "ready", "sandbox": "verified",
              "account_present": response[2]["result"].get("account") is not None,
              "checked_at": datetime.now(timezone.utc).isoformat(),
              "image_id": config["image_id"], "seccomp_sha256": config["seccomp_sha256"]}
    (STATE / "preflight.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result))


def main():
    if sys.argv[1:2] == ["codex"]:
        codex(sys.argv[2:])
        return
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    setup = sub.add_parser("build")
    setup.add_argument("--runs-root", type=Path, required=True)
    sub.add_parser("preflight")
    passthrough = sub.add_parser("codex")
    passthrough.add_argument("arguments", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    if args.command == "build":
        build(args.runs_root)
    elif args.command == "preflight":
        preflight()
    else:
        codex(args.arguments)


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, KeyError, subprocess.CalledProcessError) as error:
        print("Rule Lab runtime: " + str(error), file=sys.stderr)
        raise SystemExit(1)
