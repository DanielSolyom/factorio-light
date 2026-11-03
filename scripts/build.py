"""Build a reproducible, portal-safe ZIP containing only the mod directory."""
import hashlib
import json
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED

ROOT = Path(__file__).resolve().parents[1]


def build():
    source = ROOT / "factorio-light"
    info = json.loads((source / "info.json").read_text())
    prefix = f"{info['name']}_{info['version']}"
    output = ROOT / "dist" / f"{prefix}.zip"
    output.parent.mkdir(exist_ok=True)
    with ZipFile(output, "w", ZIP_DEFLATED, compresslevel=9) as archive:
        for path in sorted(source.rglob("*")):
            if not path.is_file():
                continue
            assert path.name in {"COPYING", "COPYING.LESSER", "LICENSE"} or path.suffix in {".lua", ".json", ".cfg", ".txt", ".md", ".png"}, path
            member = ZipInfo(f"{prefix}/{path.relative_to(source)}", (2026, 1, 1, 0, 0, 0))
            member.compress_type = ZIP_DEFLATED
            member.external_attr = 0o644 << 16
            archive.writestr(member, path.read_bytes())
    digest = hashlib.sha256(output.read_bytes()).hexdigest()
    output.with_suffix(".zip.sha256").write_text(f"{digest}  {output.name}\n")
    return output


if __name__ == "__main__":
    print(build())
