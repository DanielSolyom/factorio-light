"""Independent invariants against untouched Space Age and engine reference runs."""
import json
import math
from pathlib import Path
import sys

root = Path(sys.argv[1])


def read(profile, name):
    return json.loads((root / profile / "data/script-output" / name).read_text())


base = read("baseline", "data-raw-dump.json")
mod = read("modded", "data-raw-dump.json")
reference = read("legendary", "reference.json")
actual = read("modded", "reference.json")
assert mod["quality"] == base["quality"], "Quality prototypes were changed"
assert "pistol" not in mod.get("gun", {})
assert "spoilage" not in mod.get("item", {})
assert not any(n.startswith("quality-module") for n in mod.get("module", {}))
assert mod["recipe"]["submachine-gun"]["enabled"]
shooting_tip = mod["tips-and-tricks-item"]["shoot-targeting"]
assert shooting_tip["tag"] == "[item=submachine-gun]"
assert 'player.insert("submachine-gun")' in shooting_tip["simulation"]["init"]
assert '"pistol"' not in shooting_tip["simulation"]["init"]
assert "spoilables" not in mod["tips-and-tricks-item"]
assert not any(e.get("recipe") == "submachine-gun" for e in mod["technology"]["military"]["effects"])

items = {n: v for values in mod.values() for n, v in values.items() if "stack_size" in v}
for name, value in items.items():
    assert not value.get("spoil_ticks"), name
    assert not value.get("spoil_to_trigger_result"), name
for name, recipe in mod["recipe"].items():
    for value in list(recipe.get("ingredients", [])) + list(recipe.get("results", [])):
        assert value["name"] not in {"spoilage", "pistol"}, name
        if value.get("type", "item") == "item":
            assert value["name"] in items, (name, value)

techs = {n: t for n, t in mod["technology"].items() if not t.get("hidden") and t.get("enabled", True)}
reachable = set()
while True:
    new = {n for n, t in techs.items() if set(t.get("prerequisites", [])).issubset(reachable)}
    if new <= reachable:
        break
    reachable |= new
assert reachable == set(techs), set(techs) - reachable
for name, tech in techs.items():
    for effect in tech.get("effects", []):
        if effect["type"] == "unlock-recipe":
            assert effect["recipe"] in mod["recipe"], name
for name, recipe in base["recipe"].items():
    if name in mod["recipe"]:
        assert recipe.get("surface_conditions") == mod["recipe"][name].get("surface_conditions"), name

# Only steel chests lose their vanilla placement conditions.
platform_entities = {"steel-chest"}
for kind, values in base.items():
    if kind in {"recipe", "item", "rail-planner"}:
        continue
    for name, original in values.items():
        if name not in mod.get(kind, {}):
            continue
        conditions = mod[kind][name].get("surface_conditions")
        if name in platform_entities:
            assert not conditions, (kind, name)
        else:
            assert conditions == original.get("surface_conditions"), (kind, name)

# Scope is derived from vanilla player-placeable entities, not the mod's table.
placed = {v["place_result"] for values in base.values() for v in values.values()
          if v.get("place_result") and not v.get("hidden")}
excluded = {"simple-entity-with-owner", "simple-entity-with-force", "burner-generator",
            "plant", "tree", "infinity-container", "infinity-cargo-wagon", "infinity-pipe",
            "electric-energy-interface", "heat-interface"}
count = 0
for kind, prototypes in reference.items():
    for name, values in prototypes.items():
        if name not in actual[kind]:
            continue
        if kind == "entity" and (values["type"] in excluded or
                (name not in placed and values["type"] not in {"combat-robot", "construction-robot", "logistic-robot"})):
            continue
        for key, expected in values.items():
            if key in {"type", "get_spoil_ticks"}:
                continue
            # Infinite armour never wears out, regardless of its unused durability.
            if key == "get_durability" and values["type"] == "armor":
                continue
            got = actual[kind][name].get(key)
            if isinstance(expected, dict):
                expected = {k: v for k, v in expected.items() if k != "quality"}
                got = {k: v for k, v in (got or {}).items() if k != "quality"}
            equal = math.isclose(expected, got, rel_tol=1e-5, abs_tol=1e-5) if isinstance(expected, (int, float)) and isinstance(got, (int, float)) else expected == got
            assert equal, (kind, name, key, expected, got)
            count += 1

for kind in ["asteroid", "unit", "unit-spawner", "turret", "spider-unit", "segmented-unit", "segment"]:
    assert base[kind] == mod[kind], f"World/enemy prototypes changed: {kind}"
for kind in ["tree", "plant", "simple-entity"]:
    for name, original in base[kind].items():
        expected = json.loads(json.dumps(original).replace('"spoilage"', '"yumako-mash"'))
        assert expected == mod[kind][name], (kind, name)

barrels = 0
fluids = set()
for name, recipe in mod["recipe"].items():
    if not name.endswith("-barrel") or name.startswith("empty-") or name.endswith("-recycling"):
        continue
    inputs = [i for i in recipe.get("ingredients", []) if i.get("type") == "fluid"]
    if not inputs:
        continue
    assert len(inputs) == 1
    fluid = inputs[0]
    reverse = mod["recipe"]["empty-" + name]
    output = next(i for i in reverse["results"] if i.get("type") == "fluid")
    assert fluid["name"] == output["name"]
    assert fluid["amount"] == output["amount"] == 50
    temperature = output.get("temperature", mod["fluid"][fluid["name"]]["default_temperature"])
    assert fluid["minimum_temperature"] == fluid["maximum_temperature"] == temperature
    assert not recipe.get("allow_productivity") and not reverse.get("allow_productivity")
    assert not recipe.get("surface_conditions") and not reverse.get("surface_conditions")
    fluids.add(fluid["name"])
    barrels += 1
assert fluids == {n for n, f in mod["fluid"].items() if not f.get("parameter") and n not in {"fluid-unknown", "steam", "fusion-plasma"}}

assert barrels == 20
for fluid in ("steam", "fusion-plasma"):
    assert mod["fluid"][fluid].get("auto_barrel") == base["fluid"][fluid].get("auto_barrel")
    assert not any(fluid in name and name.endswith("-barrel") for name in items)
for name in ("assembling-machine-2", "assembling-machine-3"):
    assert mod["assembling-machine"][name]["fluid_boxes"] == base["assembling-machine"][name]["fluid_boxes"], name

# Bootstrap: yumako unlocks processing and the hand-craftable nutrient recipe.
assert "crafting" in mod["recipe"]["nutrients-from-yumako-mash"]["categories"]
assert any(e.get("recipe") == "nutrients-from-yumako-mash" for e in techs["yumako"]["effects"])
for metal in ["iron", "copper"]:
    incubation = mod["recipe"][metal + "-bacteria-cultivation"]
    assert incubation["ingredients"] == base["recipe"][metal + "-bacteria-cultivation"]["ingredients"]
    assert incubation["energy_required"] == 4 and incubation["results"][0]["amount"] == 4
    isolation = mod["recipe"][f"factorio-light-{metal}-isolation"]
    assert not isolation["allow_productivity"]
    assert isolation["ingredients"][0]["amount"] == isolation["results"][0]["amount"] == 10

for suffix, tech, speed in [("loader", "logistics", .03125), ("fast-loader", "logistics-2", .0625),
                            ("express-loader", "logistics-3", .09375), ("turbo-loader", "turbo-transport-belt", .125)]:
    name = "factorio-light-" + suffix
    assert mod["loader-1x1"][name]["speed"] == speed
    assert any(e.get("recipe") == name for e in techs[tech]["effects"])
print(f"PASS: {count} legendary engine values, {len(techs)} reachable technologies, {barrels} temperature-safe barrel pairs covering {len(fluids)} fluids")

for name, fire in base["fire"].items():
    assert fire == mod["fire"][name], f"World fire changed: {name}"
assert base["sticker"]["fire-sticker"] == mod["sticker"]["fire-sticker"]
