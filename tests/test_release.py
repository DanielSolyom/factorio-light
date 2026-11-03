"""Release integrity must fail closed before any network publication."""
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


def module(name):
    spec = importlib.util.spec_from_file_location(name, ROOT / "scripts" / f"{name}.py")
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


build = module("build").build
verified_archive = module("publish").verified_archive


class ReleaseIntegrity(unittest.TestCase):
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
