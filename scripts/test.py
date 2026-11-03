"""Run the packaged mod in isolated, real Factorio headless environments."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time

from build import build, ROOT

BIN = Path(os.environ["FACTORIO_BIN"]).resolve()
DATA = next(p.resolve() for p in [BIN.parent / "../../data", BIN.parent / "../data"]
            if (p / "base/info.json").exists())
WORK = ROOT / ".testrun"


def environment(name, mod=False, quality=False):
    path = WORK / name
    if path.exists():
        shutil.rmtree(path)
    (path / "mods").mkdir(parents=True)
    (path / "data/scenarios").mkdir(parents=True)
    config = {"mods": [{"name": n, "enabled": enabled} for n, enabled in [
        ("base", True), ("elevated-rails", True), ("recycler", True),
        ("space-age", True), ("quality", quality), ("factorio-light-space-age", mod)]]}
    (path / "mods/mod-list.json").write_text(json.dumps(config))
    if mod:
        shutil.copy2(package, path / "mods")
    (path / "config.ini").write_text(f"[path]\nread-data={DATA}\nwrite-data={path / 'data'}\n")
    return path


def run(path, name, *args, expected_failure=False):
    result = subprocess.run([str(BIN), "-c", str(path / "config.ini"),
                             "--mod-directory", str(path / "mods"), *map(str, args)],
                            capture_output=True, text=True, timeout=180)
    output = result.stdout + result.stderr
    (path / f"{name}.log").write_text(output)
    success = result.returncode == 0 and " Error " not in output
    if success == expected_failure:
        print(output[-7000:])
        raise AssertionError(f"{name}: unexpected {'success' if success else 'failure'}")
    return output


def scenario(path, name, source):
    target = path / "data/scenarios" / name
    target.mkdir(parents=True, exist_ok=True)
    shutil.copy2(ROOT / "tests" / source, target / "control.lua")
    return run(path, name, "--scenario2map", name)


if __name__ == "__main__":
    started = time.monotonic()
    version = json.loads((DATA / "base/info.json").read_text())["version"]
    assert version.startswith("2.1."), version
    package = build()
    baseline = environment("baseline")
    legendary = environment("legendary", quality=True)
    modded = environment("modded", mod=True)
    for path in [baseline, legendary, modded]:
        run(path, "dump", "--dump-data")
        print(f"PASS: {path.name} prototype load", flush=True)
    for path in [legendary, modded]:
        scenario(path, "reference", "reference.lua")
    subprocess.run([sys.executable, str(ROOT / "tests/check_data.py"), str(WORK)], check=True)
    scenario(modded, "gameplay", "gameplay.lua")
    output = run(modded, "gameplay-run", "--benchmark", modded / "data/saves/gameplay.zip",
                 "--benchmark-ticks", "3601", "--benchmark-runs", "1")
    assert "FACTORIO LIGHT GAMEPLAY PASSED" in output, output[-4000:]
    print("PASS: actual crafting, platform storage, loaders and no-spoil inventories", flush=True)
    scenario(modded, "platform-trains", "platform-trains.lua")
    output = run(modded, "platform-trains-run", "--benchmark", modded / "data/saves/platform-trains.zip",
                 "--benchmark-ticks", "3601", "--benchmark-runs", "1")
    assert "FACTORIO LIGHT PLATFORM TRAINS PASSED" in output, output[-4000:]
    print("PASS: native platform train placement, schedules, fuel and cargo", flush=True)
    scenario(modded, "freeplay-check", "freeplay.lua")
    freeplay_output = run(modded, "freeplay-run", "--benchmark", modded / "data/saves/freeplay-check.zip", "--benchmark-ticks", "2", "--benchmark-runs", "1")
    assert "FACTORIO LIGHT FREEPLAY PASSED" in freeplay_output
    for path in [legendary, modded]:
        fixture = path / "mods/player-fixture"
        fixture.mkdir()
        (fixture / "info.json").write_text(json.dumps({"name": "player-fixture", "version": "1.0.0",
            "title": "QA player fixture", "author": "Tests", "factorio_version": "2.1",
            "dependencies": ["space-age", "? factorio-light-space-age"]}))
        shutil.copy2(ROOT / "tests/player-fixture.lua", fixture / "data-final-fixes.lua")
        listing = json.loads((path / "mods/mod-list.json").read_text())
        listing["mods"].append({"name": "player-fixture", "enabled": True})
        (path / "mods/mod-list.json").write_text(json.dumps(listing))
        scenario(path, "player-check", "player-control.lua")
        run(path, "player-run", "--benchmark", path / "data/saves/player-check.zip",
            "--benchmark-ticks", "1801", "--benchmark-runs", "1")
    subprocess.run([sys.executable, str(ROOT / "tests/check-player.py"),
                    str(legendary / "data/script-output/player.json"),
                    str(modded / "data/script-output/player.json")], check=True)
    for path in [legendary, modded]:
        scenario(path, "stickers", "stickers.lua")
        run(path, "stickers-run", "--benchmark", path / "data/saves/stickers.zip",
            "--benchmark-ticks", "121", "--benchmark-runs", "1")
    expected = json.loads((legendary / "data/script-output/stickers.json").read_text())
    actual = json.loads((modded / "data/script-output/stickers.json").read_text())
    for name, values in expected.items():
        for field, value in values.items():
            tolerance = .02 if field == "health" else .001
            assert abs(value - actual[name][field]) < tolerance, (name, field, value, actual[name][field])
    cargo = environment("cargo-probe", mod=True)
    fixture = cargo / "mods/cargo-fixture"
    fixture.mkdir()
    (fixture / "info.json").write_text(json.dumps({"name": "cargo-fixture", "version": "1.0.0",
        "title": "QA cargo fixture", "author": "Tests", "factorio_version": "2.1",
        "dependencies": ["factorio-light-space-age"]}))
    (fixture / "data.lua").write_text('data.raw["cargo-bay"]["cargo-bay"].allow_unloading = true\n')
    listing = json.loads((cargo / "mods/mod-list.json").read_text())
    listing["mods"].append({"name": "cargo-fixture", "enabled": True})
    (cargo / "mods/mod-list.json").write_text(json.dumps(listing))
    scenario(cargo, "cargo-probe", "cargo-probe.lua")
    run(cargo, "cargo-run", "--benchmark", cargo / "data/saves/cargo-probe.zip",
        "--benchmark-ticks", "601", "--benchmark-runs", "1")
    transfers = json.loads((cargo / "data/script-output/cargo-probe.json").read_text())
    assert transfers["hub-out"]["chest"] > 0 and transfers["hub-in"]["hub"] > 0
    assert transfers["bay-out"]["chest"] == 0 and transfers["bay-in"]["hub"] == 0
    conflict = environment("quality-conflict", mod=True, quality=True)
    output = run(conflict, "conflict", "--dump-data", expected_failure=True)
    assert "quality" in output.lower() and "factorio-light" in output.lower()
    report = {"factorio_version": version, "mod_version": json.loads((ROOT / "factorio-light/info.json").read_text())["version"],
              "package": package.name, "sha256": hashlib.sha256(package.read_bytes()).hexdigest(),
              "source_commit": subprocess.run(["git", "rev-parse", "HEAD"], cwd=ROOT, capture_output=True, text=True).stdout.strip() or None,
              "status": "passed", "duration_seconds": round(time.monotonic() - started, 2),
              "checks": ["prototype-load", "legendary-reference", "world-invariants", "technology-graph",
                         "removed-items", "barrel-conservation", "gleba-bootstrap", "native-loader-transfer",
                         "platform-chests", "platform-trains", "no-spoilage", "freeplay-configuration", "quality-conflict",
                         "equipment-inventories", "combat-mining-research-reference", "food-and-status-effects", "cargo-bay-native-limit"]}
    (ROOT / "dist/qa-report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))
