-- Adapted from Krastorio 2's LGPL-3.0 loader prototypes. See THIRD_PARTY.md.
-- Native 1x1 loaders: no hidden inserters and no runtime transport script.
local graphics = require("prototypes.loader-graphics")
local tiers = {
  {"loader", "transport-belt", "logistics", "loader", {249, 207, 70}, "splitter"},
  {"fast-loader", "fast-transport-belt", "logistics-2", "fast-loader", {228, 24, 38}, "fast-splitter"},
  {"express-loader", "express-transport-belt", "logistics-3", "express-loader", {0, 180, 255}, "express-splitter"},
  {"turbo-loader", "turbo-transport-belt", "turbo-transport-belt", "advanced-loader", {80, 210, 50}, "turbo-splitter"}
}
for i, tier in ipairs(tiers) do
  local name = "factorio-light-" .. tier[1]
  local belt = data.raw["transport-belt"][tier[2]]
  local icon = "__factorio-light-space-age__/graphics/loaders/" .. tier[4] .. ".png"
  -- Match the splitter's costs, crafting time, machines and surface restrictions.
  -- Upgrades consume one previous-tier loader in place of its splitter.
  local recipe = table.deepcopy(data.raw.recipe[tier[6]])
  recipe.name = name
  recipe.results = {{type = "item", name = name, amount = 1}}
  if i > 1 then
    for _, ingredient in ipairs(recipe.ingredients) do
      if ingredient.name == tiers[i-1][6] then
        ingredient.name = "factorio-light-" .. tiers[i-1][1]
      end
    end
  end
  data:extend({
    {type = "item", name = name, icon = icon, subgroup = "belt",
      order = "d[loader]-" .. i, place_result = name, stack_size = 50, weight = 20000},
    recipe,
    {type = "loader-1x1", name = name, icon = icon,
      flags = {"placeable-neutral", "player-creation"},
      minable = {mining_time = 0.25, result = name},
      placeable_by = {item = name, count = 1},
      fast_replaceable_group = "factorio-light-loader",
      next_upgrade = tiers[i+1] and "factorio-light-" .. tiers[i+1][1],
      collision_box = {{-0.4, -0.45}, {0.4, 0.45}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      speed = belt.speed, container_distance = 0.75, filter_count = 5,
      energy_source = {type = "electric", usage_priority = "secondary-input", drain = "500W"},
      energy_per_item = "9kJ", max_health = 750, corpse = "small-remnants",
      resistances = {{type = "fire", percent = 90}},
      belt_animation_set = belt.belt_animation_set, animation_speed_coefficient = 32,
      structure = graphics.structure(tier[5]), structure_render_layer = "object",
      max_belt_stack_size = 4, adjustable_belt_stack_size = true,
      respect_insert_limits = true
    }
  })
  table.insert(data.raw.technology[tier[3]].effects, {type = "unlock-recipe", recipe = name})
end
