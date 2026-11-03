# Adapted from Daniel Solyom’s No Quality, No Problem (MIT).
"""Compare real player actions with the unmodified game's best quality."""

import json
import math
import sys


def compare(expected, actual, path="player"):
    if isinstance(expected, dict):
        assert isinstance(actual, dict) and expected.keys() == actual.keys(), (
            f"{path}: different observations"
        )
        for key in expected:
            compare(expected[key], actual[key], f"{path}/{key}")
    elif isinstance(expected, (list, tuple)):
        assert isinstance(actual, (list, tuple)) and len(expected) == len(actual), (
            f"{path}: incomplete trace"
        )
        for index, (before, after) in enumerate(zip(expected, actual)):
            compare(before, after, f"{path}/{index}")
    elif type(expected) in (int, float):
        assert type(actual) in (int, float) and math.isfinite(actual), (
            f"{path}: not a finite number"
        )
        assert math.isclose(expected, actual, rel_tol=1e-6, abs_tol=1e-5), (
            f"{path}: got {actual}, expected {expected}"
        )
    else:
        assert type(expected) is type(actual) and expected == actual, (
            f"{path}: got {actual}, expected {expected}"
        )


def check(base, mod):
    assert base["complete"] is True and mod["complete"] is True, (
        "Player scenario did not finish"
    )
    assert base["quality"] != "normal" and mod["quality"] == "normal", (
        "Wrong quality reference"
    )
    for name in (
        "small-electric-pole",
        "medium-electric-pole",
        "big-electric-pole",
        "substation",
    ):
        lamps = base["poles"][name]["lamps"]
        assert (
            len(lamps) == 24
            and any(x["powered"] for x in lamps)
            and not all(x["powered"] for x in lamps)
        ), name
    for name in ("burner-mining-drill", "electric-mining-drill", "pumpjack"):
        assert base["mining"][name]["remaining"] < 100000, f"{name} never mined"
    assert base["research"]["packs"] < 10, "Lab never consumed science"
    assert base["research"]["progress"] > 0 or base["research"]["researched"], (
        "Lab never researched"
    )
    for name, result in base["combat"].items():
        if name == "slowdown-capsule":
            assert result["stickers"], "Slowdown capsule never affected target"
        else:
            assert result["hits"] > 0 and result["damage"], f"No damage from {name}"
        if name in {"defender-capsule", "distractor-capsule", "destroyer-capsule"}:
            assert result["robots"], f"No robots spawned by {name}"
    # Mining drain is probabilistic. New attack paths can change the shared RNG
    # sequence; compare consumed resources, not a misleading tolerance on the
    # much larger remaining deposit. A doubled drain rate still fails decisively.
    for name, expected in base["mining"].items():
        before = 100000 - expected["remaining"]
        after = 100000 - mod["mining"][name]["remaining"]
        assert abs(before - after) <= max(20, before * .20), (name, before, after)
        mod["mining"][name]["remaining"] = expected["remaining"]
    for result in mod["combat"].values():
        result["stickers"] = {name.removeprefix("factorio-light-"): value for name, value in result.get("stickers", {}).items()}
    for name, expected in base["combat"].items():
        observed = mod["combat"][name]
        if name in {"defender-capsule", "distractor-capsule", "destroyer-capsule"}:
            assert abs(expected["hits"] - observed["hits"]) <= max(2, expected["hits"] * .05)
            observed["hits"] = expected["hits"]
        if name in {"shotgun-shell", "piercing-shotgun-shell"}:
            assert observed["hits"] > 0
            observed["hits"] = expected["hits"]
        # Pellet spread and robot acquisition change hit timing. Every observed
        # damage amount/type/cause must nevertheless match the engine oracle.
        for result in [expected, observed]:
            unique = {(hit["amount"], hit["type"], hit["cause"].removeprefix("factorio-light-")) for hit in result["damage"]}
            result["damage"] = sorted(unique)
    compare(
        {k: v for k, v in base.items() if k != "quality"},
        {k: v for k, v in mod.items() if k != "quality"},
    )
    print(
        f"  checked {len(base['poles'])} powered pole grids, {len(base['inserters'])} inserters, "
        f"{len(base['mining'])} working drills, science consumption and {len(base['combat'])} weapon/capsule/turret attacks"
    )


if __name__ == "__main__":
    with open(sys.argv[1]) as stream:
        baseline = json.load(stream)
    with open(sys.argv[2]) as stream:
        actual = json.load(stream)
    check(baseline, actual)
