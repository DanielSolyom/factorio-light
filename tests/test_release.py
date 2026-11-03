"""Release integrity must fail closed before any network publication."""
import importlib.util
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]


def module(name):
    spec = importlib.util.spec_from_file_location(name, ROOT / "scripts" / f"{name}.py")
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


build = module("build").build
publisher = module("publish")
verified_archive = publisher.verified_archive
api_key = publisher.api_key


class ReleaseIntegrity(unittest.TestCase):
    def portal_details(self):
        config = json.loads((ROOT / "portal.json").read_text())
        return {**config, "license": {"id": config["license"]},
                "description": (ROOT / config["description_file"]).read_text()}

    def test_page_verification_waits_for_cached_description(self):
        expected = self.portal_details()
        stale = {**expected, "description": "Previous description"}
        with patch.object(publisher, "request", side_effect=[{"success": True}, stale, expected]) as request, \
                patch.object(publisher.time, "sleep"):
            self.assertEqual(publisher.update_details("factorio-light-space-age", "example-key"), expected)
            writes = [call for call in request.call_args_list if len(call.args) > 1]
            self.assertEqual(len(writes), 1, "Verification must not repeat the write")

    def test_page_verification_rejects_persistent_mismatch(self):
        stale = {**self.portal_details(), "description": "Previous description"}
        with patch.object(publisher, "request", side_effect=[{"success": True}] + [stale] * 5), \
                patch.object(publisher.time, "sleep"):
            with self.assertRaisesRegex(AssertionError, "Published page differs: description"):
                publisher.update_details("factorio-light-space-age", "example-key")

    def test_api_key_trims_copy_paste_whitespace(self):
        with patch.dict(os.environ, {"FACTORIO_API_KEY": " \r\nexample-key\n\t"}):
            self.assertEqual(api_key(), "example-key")

    def test_malformed_api_key_error_does_not_disclose_value(self):
        for value in ("", " \n", "example-key\nsecond-line", "Bearer example-key", "example-key\x01"):
            with self.subTest(value=value), patch.dict(os.environ, {"FACTORIO_API_KEY": value}):
                with self.assertRaises(ValueError) as raised:
                    api_key()
                self.assertNotIn("example-key", str(raised.exception))

    def test_archive_is_reproducible(self):
        first = build().read_bytes()
        second = build().read_bytes()
        self.assertEqual(first, second)

    def test_failed_report_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            report = Path(directory) / "report.json"
            report.write_text(json.dumps({"status": "failed"}))
            with self.assertRaises(AssertionError):
                verified_archive(build(), report)

    def test_modified_archive_rejected(self):
        package = build()
        with tempfile.TemporaryDirectory() as directory:
            report = Path(directory) / "report.json"
            report.write_text(json.dumps({"status": "passed", "package": package.name, "sha256": "0" * 64}))
            with self.assertRaises(AssertionError):
                verified_archive(package, report)

    def test_no_runtime_polling(self):
        control = (ROOT / "factorio-light/control.lua").read_text()
        self.assertNotIn("on_tick", control)
        self.assertNotIn("on_nth_tick", control)


if __name__ == "__main__":
    unittest.main()
