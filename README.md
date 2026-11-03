# Factorio Light

**Less grind. More factory.**

A focused Factorio: Space Age mod for more building and less repetition.

- Fixed legendary benefits, with Quality disabled: no tiers, badges or modules.
- Nothing spoils. Hand-craft nutrients from yumako mash, incubate bacteria,
  and isolate iron and copper deliberately.
- Build ordinary and logistic chests on platforms. Barrel every fluid,
  including temperature-specific steam and fusion plasma.
- Four compact Krastorio-style loaders, unlocked alongside their splitters.
- Start and respawn with a submachine gun and 100 yellow magazines. No pistol.

Requires **Factorio 2.1.24+ and Space Age**, within the 2.1 release family.
Enable Space Age, Elevated Rails and Recycler; disable Quality and
No Quality, No Problem. Designed for new games with the official content set.

[Mod page](https://mods.factorio.com/mod/factorio-light) ·
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
storage, loader transfers, barrel conservation and freeplay starter settings.
The ZIP, SHA-256 and QA report are produced in `dist/`.

To publish, run the Release workflow with the manifest version after CI passes.
It tests the package before uploading that exact archive to GitHub and the Mod
Portal. The `FACTORIO_API_KEY` Actions secret needs Publish Mods, Upload Mods and
Edit Mods permissions. It is never written to the archive or source tree.
