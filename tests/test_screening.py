"""Diagnostic evidence integrity; no model output is semantic ground truth."""

from __future__ import annotations

import copy
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from rulelab import screening
from rulelab.screening import (
    execute,
    input_changes,
    json_bytes,
    load_json,
    validate_fixture,
    validate_query,
    verify_manifest,
    verify_records,
)

REPOSITORY = Path(__file__).resolve().parents[1]
FROZEN_MANIFEST = REPOSITORY / "docs/analysis/luna-screening-20261011/manifest.json"


def development_fixture() -> dict:
    return {
        "measure_id": "o6_3",
        "run_id": "synthetic-run",
        "query": "data.oepul.o6_3.result",
        "input_contract_note": "Ausschließlich synthetische Betriebsfakten.",
        "output_contract_note": "Native Teilbefunde ohne Gesamtförderfreigabe.",
        "case_origin": "Entwicklungsprobe ohne unabhängiges Expertenlabel.",
        "cases": [
            {
                "case_id": "baseline",
                "purpose": "Synthetische Basis ausführen und Ausgaben beobachten.",
                "input": {"farm": {"silage_storage": False}},
            }
        ],
        "references": [
            {
                "path": "runs/synthetic-run/workspace/policy/measure.rego",
                "detail": "Native Bedingung und Ausgabepunkt im Kandidaten.",
            }
        ],
        "open_dependencies": ["Unabhängiges fachliches Sollurteil steht aus."],
    }


class QueryBoundaryTests(unittest.TestCase):
    def test_native_path_and_explicit_small_projection_are_allowed(self):
        for query in (
            "data.oepul.o6_3.result",
            "data.o6_1b.eligible",
            '{"eligible": data.o6_1b.eligible, "premium": data.o6_1b.arable_base_premium}',
        ):
            with self.subTest(query=query):
                validate_query(query)

    def test_remote_calls_operators_and_unbounded_data_queries_are_rejected(self):
        for query in (
            'http.send({"method": "GET", "url": "https://example.invalid"})',
            'data.oepul.o6_3.result; http.send({"method": "GET", "url": "https://example.invalid"})',
            '{"remote": http.send({"method": "GET", "url": "https://example.invalid"})}',
            "data",
            "data.o6_3.result[_]",
            "data.o6_3.result == true",
            '{"values": [x | x := data.o6_3.result[_]]}',
            "",
        ):
            with self.subTest(query=query), self.assertRaises(ValueError):
                validate_query(query)


class FixtureContractTests(unittest.TestCase):
    def test_synthetic_fixture_and_explicit_unexecutable_gap_are_allowed(self):
        validate_fixture(development_fixture(), "o6_3", "synthetic-run")
        gap = development_fixture()
        gap["cases"] = []
        gap["gap"] = "Keine belegte Zuordnung vom Profil zur nativen Eingabe."
        validate_fixture(gap, "o6_3", "synthetic-run")

    def test_candidate_identity_cannot_drift(self):
        for key, changed in (("measure_id", "o6_4"), ("run_id", "other-run")):
            fixture = development_fixture()
            fixture[key] = changed
            with self.subTest(key=key), self.assertRaises(ValueError):
                validate_fixture(fixture, "o6_3", "synthetic-run")

    def test_diagnostic_cases_cannot_smuggle_semantic_expected_labels(self):
        for forbidden in ("expected", "expected_output", "golden_label"):
            fixture = development_fixture()
            fixture["cases"][0][forbidden] = False
            with self.subTest(field=forbidden), self.assertRaises(ValueError):
                validate_fixture(fixture, "o6_3", "synthetic-run")

    def test_duplicate_cases_empty_gap_and_oversized_case_set_are_rejected(self):
        malformed = []
        duplicate = development_fixture()
        duplicate["cases"].append(copy.deepcopy(duplicate["cases"][0]))
        malformed.append(duplicate)
        empty = development_fixture()
        empty["cases"] = []
        malformed.append(empty)
        oversized = development_fixture()
        oversized["cases"] = [
            {"case_id": f"probe-{i}", "purpose": "Entwicklungsprobe.", "input": {}}
            for i in range(4)
        ]
        malformed.append(oversized)
        for fixture in malformed:
            with self.subTest(cases=fixture["cases"]), self.assertRaises(ValueError):
                validate_fixture(fixture, "o6_3", "synthetic-run")

    def test_descriptions_inputs_and_dependencies_must_remain_explicit(self):
        mutations = (
            lambda f: f.update(input_contract_note=""),
            lambda f: f.update(output_contract_note=""),
            lambda f: f.update(case_origin=""),
            lambda f: f["cases"][0].update(purpose=""),
            lambda f: f["cases"][0].update(input=[]),
            lambda f: f.update(open_dependencies=[{}]),
        )
        for mutate in mutations:
            fixture = development_fixture()
            mutate(fixture)
            with self.subTest(fixture=fixture), self.assertRaises(ValueError):
                validate_fixture(fixture, "o6_3", "synthetic-run")

    def test_reference_paths_cannot_escape_the_repository(self):
        for path in ("/tmp/outside.rego", "../outside.rego", "runs/../../outside.rego"):
            fixture = development_fixture()
            fixture["references"][0]["path"] = path
            with self.subTest(path=path), self.assertRaises(ValueError):
                validate_fixture(fixture, "o6_3", "synthetic-run")


class InputChangeTests(unittest.TestCase):
    def test_removed_value_is_distinct_from_explicit_null(self):
        changes = input_changes({"storage": False}, {"storage": None})
        self.assertEqual(
            [
                {
                    "path": "/storage",
                    "before": {"present": True, "value": False},
                    "after": {"present": True, "value": None},
                }
            ],
            changes,
        )
        self.assertEqual(
            [
                {
                    "path": "/storage",
                    "before": {"present": True, "value": None},
                    "after": {"present": False},
                }
            ],
            input_changes({"storage": None}, {}),
        )

    def test_nested_arrays_and_json_pointer_escaping_preserve_changed_fact(self):
        before = {"a/b": {"~category": [170, None]}}
        after = {"a/b": {"~category": [171, None, False]}}
        changes = {item["path"]: item for item in input_changes(before, after)}
        self.assertEqual({"/a~1b/~0category/0", "/a~1b/~0category/2"}, set(changes))
        self.assertEqual({"present": True, "value": 170}, changes["/a~1b/~0category/0"]["before"])
        self.assertEqual({"present": True, "value": 171}, changes["/a~1b/~0category/0"]["after"])
        self.assertEqual({"present": False}, changes["/a~1b/~0category/2"]["before"])
        self.assertEqual({"present": True, "value": False}, changes["/a~1b/~0category/2"]["after"])

    def test_boolean_and_numeric_facts_are_different_json_types(self):
        self.assertEqual(
            [
                {
                    "path": "/flag",
                    "before": {"present": True, "value": True},
                    "after": {"present": True, "value": 1},
                }
            ],
            input_changes({"flag": True}, {"flag": 1}),
        )

    def test_unchanged_input_has_no_diagnostic_changes(self):
        value = {"animals": [{"count": 3}], "unknown": None, "area": 2.5}
        self.assertEqual([], input_changes(value, copy.deepcopy(value)))


class JsonEvidenceTests(unittest.TestCase):
    def test_json_bytes_are_deterministic_utf8_and_preserve_null(self):
        first = json_bytes({"z": None, "a": "Mähgut"})
        self.assertEqual(first, json_bytes({"a": "Mähgut", "z": None}))
        self.assertTrue(first.endswith(b"\n"))
        decoded = first.decode("utf-8")
        self.assertIn("Mähgut", decoded)
        self.assertLess(decoded.index('"a"'), decoded.index('"z"'))
        self.assertEqual({"a": "Mähgut", "z": None}, json.loads(decoded))

    def test_nonfinite_values_cannot_be_frozen_as_json_evidence(self):
        for value in (float("nan"), float("inf"), float("-inf")):
            with self.subTest(value=value), self.assertRaises(ValueError):
                json_bytes({"value": value})

    def test_json_loader_rejects_duplicate_keys_nonfinite_values_and_nonobjects(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "fixture.json"
            for raw in (
                '{"measure_id":"o6_3","measure_id":"o6_4"}',
                '{"input":{"value":1,"value":2}}',
                '{"value":NaN}',
                '{"value":Infinity}',
                '{"value":-Infinity}',
                "[]",
            ):
                path.write_text(raw, encoding="utf-8")
                with self.subTest(raw=raw), self.assertRaises(ValueError):
                    load_json(path)
            path.write_text('{"input":{"missing":null}}', encoding="utf-8")
            self.assertEqual({"input": {"missing": None}}, load_json(path))


class FrozenRecordTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name) / "repository"
        self.root.mkdir()
        self.artifact = self.root / "candidate.rego"
        self.content = b"package diagnostic\n"
        self.artifact.write_bytes(self.content)
        self.record = {
            "path": "candidate.rego",
            "sha256": hashlib.sha256(self.content).hexdigest(),
            "bytes": len(self.content),
        }

    def test_original_records_verify_without_changing_the_file(self):
        verify_records(self.root, [self.record])
        self.assertEqual(self.content, self.artifact.read_bytes())

    def test_same_length_hash_change_size_change_and_missing_file_are_rejected(self):
        self.artifact.write_bytes(b"package diagnostik\n")
        self.assertEqual(len(self.content), self.artifact.stat().st_size)
        with self.assertRaises(ValueError):
            verify_records(self.root, [self.record])
        self.artifact.write_bytes(self.content)
        wrong_size = dict(self.record, bytes=len(self.content) + 1)
        with self.assertRaises(ValueError):
            verify_records(self.root, [wrong_size])
        self.artifact.unlink()
        with self.assertRaises(ValueError):
            verify_records(self.root, [self.record])

    def test_literal_and_symlink_path_escapes_are_rejected(self):
        outside = self.root.parent / "outside.rego"
        outside.write_bytes(self.content)
        for path in ("../outside.rego", str(outside)):
            with self.subTest(path=path), self.assertRaises(ValueError):
                verify_records(self.root, [dict(self.record, path=path)])
        link = self.root / "escaped.rego"
        link.symlink_to(outside)
        with self.assertRaises(ValueError):
            verify_records(self.root, [dict(self.record, path="escaped.rego")])


class FrozenManifestTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = load_json(FROZEN_MANIFEST)

    def test_frozen_manifest_binds_all_candidates_and_native_load_paths(self):
        verify_manifest(REPOSITORY, self.manifest)
        self.assertEqual(26, len(self.manifest["entries"]))
        for entry in self.manifest["entries"]:
            self.assertTrue(entry["load_paths"])
            self.assertTrue(all("/workspace/tests/" not in path for path in entry["load_paths"]))

    def test_duplicate_and_missing_candidates_are_rejected(self):
        for mutation in ("duplicate", "missing"):
            manifest = copy.deepcopy(self.manifest)
            if mutation == "duplicate":
                manifest["entries"][1] = copy.deepcopy(manifest["entries"][0])
            else:
                manifest["entries"].pop()
            with self.subTest(mutation=mutation), self.assertRaises(ValueError):
                verify_manifest(REPOSITORY, manifest)

    def test_model_tests_cannot_be_added_to_the_native_evaluation_bundle(self):
        manifest = copy.deepcopy(self.manifest)
        entry = manifest["entries"][0]
        test_artifact = next(
            item["path"] for item in entry["artifacts"]
            if "/workspace/tests/" in item["path"] and item["path"].endswith(".rego")
        )
        entry["load_paths"].append(test_artifact)
        with self.assertRaisesRegex(ValueError, "Evaluation load list differs"):
            verify_manifest(REPOSITORY, manifest)

    def test_valid_file_hash_cannot_replace_the_historical_profile_binding(self):
        manifest = copy.deepcopy(self.manifest)
        manifest["entries"][0]["profile"] = copy.deepcopy(manifest["entries"][1]["fixture"])
        with self.assertRaisesRegex(ValueError, "Manifest profile differs"):
            verify_manifest(REPOSITORY, manifest)

    def test_removing_historical_sources_is_rejected_even_when_remaining_hashes_match(self):
        manifest = copy.deepcopy(self.manifest)
        manifest["entries"][0]["sources"].pop()
        with self.assertRaisesRegex(ValueError, "Manifest sources differ"):
            verify_manifest(REPOSITORY, manifest)

    def test_generation_attempt_must_match_the_bound_run_metadata(self):
        manifest = copy.deepcopy(self.manifest)
        manifest["entries"][0]["generation_attempt"] += 1
        with self.assertRaisesRegex(ValueError, "generation_attempt"):
            verify_manifest(REPOSITORY, manifest)

    def test_runtime_pin_records_cannot_be_omitted(self):
        for records in ([], self.manifest["runtime_records"][:1]):
            manifest = copy.deepcopy(self.manifest)
            manifest["runtime_records"] = records
            with self.subTest(records=records), self.assertRaisesRegex(ValueError, "both runtime pin files"):
                verify_manifest(REPOSITORY, manifest)


class ExecutionStatusTests(unittest.TestCase):
    def test_defined_null_undefined_and_runtime_error_remain_distinct(self):
        # This tests interpreter-result classification, not policy semantics.
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            policy = root / "runs/synthetic-run/workspace/policy/measure.rego"
            policy.parent.mkdir(parents=True)
            policy.write_text("package diagnostic\n", encoding="utf-8")
            content = policy.read_bytes()
            fixture = development_fixture()
            fixture["cases"] = [
                {"case_id": name, "purpose": "OPA-Ergebnisform unterscheiden.", "input": {}}
                for name in ("baseline", "variation", "missing_fact")
            ]
            fixture_path = root / "fixture.json"
            fixture_path.write_bytes(json_bytes(fixture))
            binary = root / "synthetic-opa"
            binary.write_bytes(b"nonexecutable mocked interpreter")
            checksum_path = root / "runner/validation/opa-checksums.json"
            checksum_path.parent.mkdir(parents=True)
            checksum_path.write_bytes(json_bytes({
                "synthetic": {screening.opa_platform_key(): {
                    "sha256": hashlib.sha256(binary.read_bytes()).hexdigest()
                }}
            }))
            entry = {
                "fixture": {"path": "fixture.json"},
                "load_paths": [policy.relative_to(root).as_posix()],
                "artifacts": [{
                    "path": policy.relative_to(root).as_posix(),
                    "sha256": hashlib.sha256(content).hexdigest(),
                    "bytes": len(content),
                }],
            }
            manifest = {"opa_version": "synthetic", "entries": [entry]}
            responses = [
                {"exit_code": 0, "json": {"builtins": []}},
                {"exit_code": 0, "json": {}},
                {"exit_code": 0, "json": {"result": [{"expressions": [{"value": None}]}]}},
                {"exit_code": 0, "json": {}},
                {"exit_code": 2, "json": {"errors": [{"code": "eval_builtin_error"}]}},
            ]
            with (
                patch.object(screening, "verify_manifest") as verify,
                patch.object(screening, "verify_opa_binary"),
                patch.object(screening, "diagnostic_inventory", return_value={}),
                patch.object(screening, "run_opa", side_effect=responses),
            ):
                result = execute(root, manifest, binary)
            self.assertEqual(2, verify.call_count)
            cases = result["measures"][0]["cases"]
            self.assertEqual(["defined", "undefined", "runtime_error"], [case["status"] for case in cases])
            self.assertIn("output", cases[0])
            self.assertIsNone(cases[0]["output"])
            self.assertNotIn("output", cases[1])
            self.assertNotIn("output", cases[2])
            self.assertTrue(cases[1]["output_changed_from_baseline"])


class NativeBundleReplayTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        configured = os.environ.get("OPA_BIN")
        if not configured or not Path(configured).is_file() or not os.access(configured, os.X_OK):
            raise unittest.SkipTest("OPA_BIN required for native candidate replay")
        cls.opa = Path(configured)
        cls.manifest = load_json(FROZEN_MANIFEST)
        cls.loaded_bundle_files = []
        native_run_opa = screening.run_opa

        def observe_loads(binary, args, cwd, payload=None):
            if args[0] in {"check", "eval"}:
                cls.loaded_bundle_files.extend(
                    path.relative_to(cwd).as_posix()
                    for path in (cwd / "bundle").rglob("*") if path.is_file()
                )
            return native_run_opa(binary, args, cwd, payload)

        verify_manifest(REPOSITORY, cls.manifest)
        with patch.object(screening, "run_opa", side_effect=observe_loads):
            cls.observations = execute(REPOSITORY, cls.manifest, cls.opa)
        verify_manifest(REPOSITORY, cls.manifest)

    def test_isolated_loader_preserves_direct_native_directory_namespaces(self):
        entry = next(item for item in self.manifest["entries"] if item["measure_id"] == "o6_18")
        fixture = load_json(REPOSITORY / entry["fixture"]["path"])
        workspace = REPOSITORY / "runs" / entry["run_id"] / "workspace"
        direct = subprocess.run(
            [str(self.opa), "eval", "--format=json", "--stdin-input", "--strict-builtin-errors",
             "--data", str(workspace / "policy"), "--data", str(workspace / "data"), fixture["query"]],
            input=json_bytes(fixture["cases"][0]["input"]).decode("utf-8"),
            capture_output=True, text=True, timeout=20, check=False,
        )
        self.assertEqual(0, direct.returncode, direct.stderr)
        native = json.loads(direct.stdout)
        observed = next(item for item in self.observations["measures"] if item["measure_id"] == "o6_18")
        self.assertEqual("defined", observed["cases"][0]["status"])
        self.assertEqual(native["result"][0]["expressions"][0]["value"], observed["cases"][0]["output"])

    def test_all_candidates_are_isolated_from_model_authored_tests(self):
        self.assertEqual(26, len(self.observations["measures"]))
        self.assertTrue(self.loaded_bundle_files)
        self.assertTrue(all(path.startswith(("bundle/policy/", "bundle/data/")) for path in self.loaded_bundle_files))
        self.assertTrue(all("/tests/" not in path for path in self.loaded_bundle_files))
        verify_manifest(REPOSITORY, self.manifest)


if __name__ == "__main__":
    unittest.main()
