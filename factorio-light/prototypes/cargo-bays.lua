-- Cargo bays keep their storage and cargo hatches, and also expose the landing
-- pad's inventory. Bays must connect through a chain, with no radius limit.
local bay = data.raw["cargo-bay"]["cargo-bay"]
bay.allow_unloading = true
bay.use_unloading_distance_limit = false
bay.localised_description = {"entity-description.factorio-light-cargo-bay"}

-- The engine's allow_unloading only supports landing pads. On platforms an
-- invisible, output-only proxy exposes the connected hub's real inventory.
-- It has no inventory of its own and never copies or periodically moves items.
data:extend({{
  type = "proxy-container", name = "factorio-light-cargo-bay-output",
  -- player-creation is required for native loader connections to the proxy.
  flags = {"player-creation", "placeable-off-grid", "not-on-map", "not-blueprintable",
    "not-deconstructable", "not-upgradable", "not-flammable",
    "not-in-kill-statistics", "no-automated-item-insertion"},
  collision_box = table.deepcopy(bay.collision_box),
  selection_box = table.deepcopy(bay.selection_box),
  collision_mask = {layers = {}}, selectable_in_game = false,
  hidden = true, hidden_in_factoriopedia = true, draw_inventory_content = false
}})

-- Existing entities and carried items are converted by the JSON migration.
data.raw["cargo-bay"]["landing-pad-unloading-bay"] = nil
data.raw.item["landing-pad-unloading-bay"] = nil
data.raw.recipe["landing-pad-unloading-bay"] = nil
data.raw.technology["landing-pad-unloading-bay"] = nil
