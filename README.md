# Factorio Light: Space Age

[![QA](https://github.com/DanielSolyom/factorio-light/actions/workflows/ci.yml/badge.svg)](https://github.com/DanielSolyom/factorio-light/actions/workflows/ci.yml)
[![Mod portal](https://img.shields.io/factorio-mod-portal/v/factorio-light-space-age?label=mod%20portal&color=orange)](https://mods.factorio.com/mod/factorio-light-space-age)
[![Downloads](https://img.shields.io/factorio-mod-portal/dt/factorio-light-space-age?color=blue)](https://mods.factorio.com/mod/factorio-light-space-age)
[![Factorio](https://img.shields.io/badge/factorio-2.1-yellow)](https://factorio.com)
[![License: LGPL-3.0](https://img.shields.io/badge/license-LGPL--3.0-green.svg)](https://github.com/DanielSolyom/factorio-light/blob/main/LICENSE)

**Less grind. More factory.**

A focused Factorio: Space Age mod for more building and less repetition.

- Fixed legendary benefits, with Quality disabled: no quality tiers, indicators or modules.
  Labs keep legendary research speed; science packs retain their vanilla research value.
- Nothing spoils. Hand-craft nutrients from yumako mash, incubate bacteria,
  and isolate iron and copper deliberately.
- Build steel chests, all five logistic chest types and roboports on platforms.
  Use logistic robots to move supplies around your ships.
- Barrel all fluids except steam and fusion plasma,
  including water, thruster fuel and oxidizer for platform-to-platform supply.
- Unload through ordinary cargo bays on planets and platforms, with no distance
  limit along a connected bay chain. Cargo bays keep their storage and cargo
  hatches; the separate unloading bay and its research are merged into them.
- Four compact Krastorio-style loaders, unlocked alongside their splitters.
  Recipes match the corresponding splitter, using one previous-tier loader
  for upgrades. Yellow needs no steel; green uses a foundry on Vulcanus.
  They need electricity and snap to adjacent machines and belts when placed.
  Press R over a placed loader to switch between loading and unloading.
- Start and respawn with a submachine gun and 100 yellow magazines. No pistol.

Requires **Factorio 2.1.24+ and Space Age**, within the 2.1 release family.
Enable Space Age, Elevated Rails and Recycler; disable Quality.
Designed for new games with the official content set.

[Mod page](https://mods.factorio.com/mod/factorio-light-space-age) ·
[Releases](https://github.com/DanielSolyom/factorio-light/releases) ·
[Report a bug](https://github.com/DanielSolyom/factorio-light/issues) ·
[Gameplay details](PORTAL.md)

Bug reports are welcome. The supported content set is vanilla Space Age;
compatibility with other overhaul mods is not guaranteed.

GNU LGPLv3. [Credits and third-party notices](factorio-light/THIRD_PARTY.md).

## Build and test

```sh
python3 scripts/build.py
FACTORIO_BIN=/path/to/factorio python3 scripts/test.py
```

Python 3.11+ and the Factorio 2.1.24 headless package are sufficient. All test
saves, configuration and mods are isolated in `.testrun/`. The real installation
and saves are never changed. Tests use the release ZIP, an untouched Space Age
baseline, and a separate legendary-quality reference.

CI checks prototype invariants, technology reachability, recipe inputs,
legendary stats, equipment, combat, mining, science consumption, platform
storage and placement restrictions, loader crafting/recycling recipes, loader transfers and real-player loader
placement in every direction (including existing-loader repair), cargo-bay unloading
beyond 59 tiles on planets and platforms, disconnection/reconnection, existing-save
cargo-bay migration, barrel conservation,
native platform-to-platform fluid supplies, powered platform roboports and robot
deliveries through all five logistic chest types, freeplay starter settings and
real-player starting/respawn ammunition slots.
The ZIP, SHA-256 and QA report are produced in `dist/`.

To publish, run the Release workflow with the manifest version after CI passes.
It tests the package before uploading that exact archive to GitHub and the Mod
Portal. The `FACTORIO_API_KEY` Actions secret needs Publish Mods, Upload Mods and
Edit Mods permissions. It is never written to the archive or source tree.

For description and summary edits, use the Update Mod Portal page workflow.
It updates and verifies the listing without uploading a new mod version.
