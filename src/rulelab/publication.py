"""Portable path records for public metadata; never rewrite execution arguments."""

from __future__ import annotations

from pathlib import Path
import re
from typing import Any


_TAIL = r"(?:/[^\s\"'<>`,;()\[\]{}\\]+)*"
HOST_PATH = re.compile(
    r"(?<![\w/.:])/(?:Users|home|workspace|workspaces|tmp|private/var|opt|usr|srv|var)"
    r"(?=/|[\s\"'<>`,;()\[\]{}\\]|$)" + _TAIL
)


def public_metadata(value: Any, root: Path) -> Any:
    """Copy metadata, using repository-relative paths and external/name labels.

    External labels retain a filename for provenance, not an executable path.
    Legacy records from another checkout are recognized by the repository name.
    Only use this on metadata: source documents and model evidence stay intact.
    """
    base = str(root.absolute())
    pattern = re.compile(r"(?<![\w/.:])" + re.escape(base) + r"(?=/|[\s\"']|$)" + _TAIL)

    def relative(path: str) -> str:
        if path == base:
            return "."
        if path.startswith(base + "/"):
            return path[len(base) + 1:]
        marker = "/oepul-rule-lab/"
        if marker in path:
            return path.rsplit(marker, 1)[1]
        return "external/" + Path(path).name

    if isinstance(value, dict):
        return {key: public_metadata(item, root) for key, item in value.items()}
    if isinstance(value, list):
        return [public_metadata(item, root) for item in value]
    if isinstance(value, str):
        # A complete argument can contain spaces in its checkout or filename.
        if "\n" not in value and (
            value == base or value.startswith(base + "/")
            or (value.startswith("/") and "/oepul-rule-lab/" in value)
        ):
            return relative(value)
        def replace(match: re.Match[str]) -> str:
            return relative(match.group())

        return HOST_PATH.sub(replace, pattern.sub(replace, value))
    return value
