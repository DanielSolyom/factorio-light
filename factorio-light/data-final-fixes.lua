-- Ordinary generated barrels use a fluid's default temperature. Constrain the
-- input to that same temperature so no barrel can cool or heat a fluid silently.
local shooting_tip = data.raw["tips-and-tricks-item"]["shoot-targeting"]
shooting_tip.tag = "[item=submachine-gun]"
shooting_tip.simulation.init = shooting_tip.simulation.init:gsub('"pistol"', '"submachine-gun"')

for _, fluid in ipairs({"water", "sulfuric-acid", "crude-oil", "heavy-oil", "light-oil",
  "petroleum-gas", "lubricant", "ammoniacal-solution", "ammonia", "fluorine",
  "fluoroketone-cold", "fluoroketone-hot", "holmium-solution", "electrolyte",
  "lithium-brine", "lava", "molten-iron", "molten-copper", "thruster-fuel", "thruster-oxidizer"}) do
  local fill = assert(data.raw.recipe[fluid .. "-barrel"])
  local empty = assert(data.raw.recipe["empty-" .. fluid .. "-barrel"])
  fill.surface_conditions, empty.surface_conditions = nil, nil
  fill.allow_productivity, empty.allow_productivity = false, false
  for _, ingredient in ipairs(fill.ingredients) do
    if ingredient.type == "fluid" then
      ingredient.minimum_temperature = data.raw.fluid[fluid].default_temperature
      ingredient.maximum_temperature = data.raw.fluid[fluid].default_temperature
    end
  end
end

-- Remove obsolete tutorial simulations as well as their dependency links.
local removed = {spoilables = true, ["spoilables-result"] = true, ["spoilables-research"] = true}
for name in pairs(removed) do data.raw["tips-and-tricks-item"][name] = nil end
data.raw["tips-and-tricks-item-category"].spoilables = nil
for _, tip in pairs(data.raw["tips-and-tricks-item"]) do
  if tip.dependencies then
    for i = #tip.dependencies, 1, -1 do
      if removed[tip.dependencies[i]] then table.remove(tip.dependencies, i) end
    end
  end
end

-- No timers also means no inherited freshness in recipe products.
for _, recipe in pairs(data.raw.recipe) do
  for _, result in ipairs(recipe.results or {}) do
    result.percent_spoiled = nil
    result.reset_freshness_on_craft = nil
  end
end
