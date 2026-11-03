# Less grind. More factory.

**Factorio Light** brings fixed legendary machinery, stable ingredients and
more flexible logistics to Space Age. Spend your time designing production
lines, building platforms and expanding across planets.

## Build with the good stuff

Vanilla machines, logistics, weapons and equipment receive fixed legendary
benefits. Quality is **disabled**, with an explicit incompatible dependency:
there are no quality tiers, quality badges, quality modules or inert substitutes.
Enemy and asteroid stats stay normal.

The bonuses are explicit prototype edits for the official 2.1 content set.
They do not dynamically boost everything installed by other mods.

## Gleba, on your schedule

Nothing spoils: fruit, mash, jelly, bioflux, nutrients, bacteria, eggs, captured
spawner items and agricultural science all keep. Egg items do not hatch in storage.

- **Start by hand:** process yumako and craft nutrients from mash before your
  first biochamber. Assemblers can make those nutrients too.
- **Grow a culture:** iron and copper bacteria incubation keeps the original
  bacteria + bioflux recipe and biochamber productivity.
- **Choose when to harvest:** iron/copper isolation converts 10 bacteria into
  10 ore in 0.2 recipe seconds, without extra productivity. Keep a seed culture!
- **Use biomass:** yumako mash replaces the spoilage item in the remaining
  recipes and natural harvests. Sulfur, carbon, advanced efficiency modules,
  agricultural towers and overgrowth soils remain obtainable.

With no modules, each fixed-stat biochamber cultivates a net **6.25 bacteria/s**
after reserving its seed. One isolation biochamber can handle 40 such incubators,
so replacing passive decay adds about 2.4% to the combined machine count per ore.

The ordinary Gleba research path and planetary recipe restrictions remain.
Living captive spawners still need food; pentapod enemies still attack.

## Give your platforms some room

Steel chests can be built on platforms. Wooden, iron and logistic chests, along
with roboports, retain their normal restrictions.

Build an orbital railway: locomotives, cargo/fluid/artillery wagons, train stops,
signals, ground rails and elevated rails are allowed, including ramps and supports.
Trains use their normal fuel, schedules and railway rules.

Inserters still access a platform through its main hub. Factorio 2.1's cargo-bay
unloading flag applies to planetary landing pads and does not enable platform
bay loading or unloading. No scripted inventory proxy is added.

Barrel and empty **20 fluids** on planets or platforms: every real vanilla fluid
except steam and fusion plasma. This includes water, thruster fuel, thruster
oxidizer, molten metals, lava, ammonia, fluorine and the other planetary fluids.

Supply one platform from another: fill water, thruster fuel or thruster oxidizer
barrels and insert them into the supplying hub. Enable **Provide materials to
other platforms** there, then request the filled barrels from **platforms** in
the receiving hub. Both platforms must be in the same orbit with unloading
allowed; avoid requesting those same filled barrels from platforms on the supplier.
Empty the delivered barrels in assemblers. To reuse them, enable providing on
the receiver too and request empty barrels back at the supplier. This uses
Factorio 2.1's native platform transfers.

Each barrel holds 50 fluid and returns the empty barrel. Filling and emptying
have no productivity bonus and preserve each fluid's default temperature.
Steam and fusion plasma keep their vanilla transport rules.

## Load, unload, build

Compact native **1×1 loaders**, adapted from Krastorio 2, move a full belt of
their tier: yellow, red, blue and turbo. Each unlocks with the technology that
unlocks its splitter. They use electricity, support belt stacking, and respect
machine insertion limits. No hidden inserters or transport tick scripts.

Freeplay starts and respawns provide a **submachine gun and 100 yellow magazines**.
The gun is craftable immediately, and the pistol is removed.

## Before you start

Requires **Factorio 2.1.24 or later in the 2.1 series, with Space Age**.
Enable Space Age, Elevated Rails and Recycler. Disable Quality and
No Quality, No Problem.

Start a new game. This is an intentional balance change, with a focused official
content target rather than a promise of compatibility with every overhaul.
Existing Quality saves are not a supported migration path.

[Source and documentation](https://github.com/DanielSolyom/factorio-light) ·
[Bug reports](https://github.com/DanielSolyom/factorio-light/issues) ·
[Tested downloads](https://github.com/DanielSolyom/factorio-light/releases)

Krastorio 2 loader code and artwork credited to its
authors; GNU LGPLv3, with notices and source included. Unofficial; not affiliated
with Wube Software.
