-- The shipped Space Age item set, intentionally explicit and reviewable.
local function stable(kind, name)
  local item = data.raw[kind][name]
  item.spoil_ticks = nil
  item.spoil_result = nil
  item.spoil_to_trigger_result = nil
end
stable("item", "agricultural-science-pack")
stable("item", "copper-bacteria")
stable("item", "iron-bacteria")
stable("item", "nutrients")
stable("item", "captive-biter-spawner")
stable("item", "biter-egg")
stable("item", "pentapod-egg")
stable("capsule", "raw-fish")
stable("capsule", "yumako")
stable("capsule", "jellynut")
stable("capsule", "yumako-mash")
stable("capsule", "jelly")
stable("capsule", "bioflux")

-- Mash is usable biomass. Replace every vanilla consumer of the removed item.
local function biomass(recipe)
  for _, ingredient in ipairs(data.raw.recipe[recipe].ingredients) do
    if ingredient.name == "spoilage" then ingredient.name = "yumako-mash" end
  end
end
biomass("efficiency-module-3")
biomass("overgrowth-yumako-soil")
biomass("overgrowth-jellynut-soil")
biomass("biosulfur")
biomass("agricultural-tower")
biomass("burnt-spoilage")
data.raw.recipe["burnt-spoilage"].localised_name = {"recipe-name.factorio-light-carbon-from-mash"}
data.raw.recipe["burnt-spoilage"].icon = data.raw.item.carbon.icon

-- This recipe must work by hand/assembler BEFORE the first nutrient-fuelled
-- biochamber exists. Its original 4 mash -> 6 nutrients balance is retained.
data.raw.recipe["nutrients-from-yumako-mash"].categories = {"organic", "crafting"}
table.insert(data.raw.technology.yumako.effects,
  {type = "unlock-recipe", recipe = "nutrients-from-yumako-mash"})

for _, metal in ipairs({"iron", "copper"}) do
  local bacteria = metal .. "-bacteria"
  -- Seeding keeps its original yield and research. Its waste is no longer needed.
  local seed = data.raw.recipe[bacteria]
  seed.results = {{type = "item", name = bacteria, amount = 1, independent_probability = 0.1}}
  data.raw.recipe[bacteria .. "-cultivation"].localised_name =
    {"recipe-name.factorio-light-incubation", {"item-name." .. bacteria}}
  data.raw.recipe[bacteria .. "-cultivation"].results[1].reset_freshness_on_craft = nil
  local isolation = "factorio-light-" .. metal .. "-isolation"
  data:extend({{
    type = "recipe", name = isolation,
    localised_name = {"recipe-name." .. isolation},
    icons = {
      {icon = "__base__/graphics/icons/" .. metal .. "-ore.png", icon_size = 64},
      {icon = "__space-age__/graphics/icons/" .. bacteria .. ".png", icon_size = 64, scale = 0.25, shift = {-8, 8}}
    },
    categories = {"organic", "crafting"}, subgroup = "agriculture-processes",
    order = seed.order .. "-isolation", enabled = false,
    energy_required = 0.2, allow_productivity = false, auto_recycle = false,
    ingredients = {{type = "item", name = bacteria, amount = 10}},
    results = {{type = "item", name = metal .. "-ore", amount = 10}}
  }})
  table.insert(data.raw.technology[metal == "iron" and "jellynut" or "yumako"].effects,
    {type = "unlock-recipe", recipe = isolation})
end

-- Natural biomass harvests keep their quantities, now as usable mash.
local function harvest(kind, name)
  for _, result in ipairs(data.raw[kind][name].minable.results or {}) do
    if result.name == "spoilage" then result.name = "yumako-mash" end
  end
end
for _, name in ipairs({"cuttlepop", "slipstack", "funneltrunk", "hairyclubnub",
  "teflilly", "lickmaw", "stingfrond", "boompuff", "sunnycomb", "water-cane"}) do
  harvest("tree", name)
end
for _, name in ipairs({"small-stomper-shell", "medium-stomper-shell", "big-stomper-shell"}) do
  harvest("simple-entity", name)
end

data.raw.item.spoilage = nil
data.raw.recipe["nutrients-from-spoilage"] = nil
data.raw.recipe["spoilage-recycling"] = nil
for _, name in ipairs({"agriculture", "recycling"}) do
  local effects = data.raw.technology[name].effects
  for i = #effects, 1, -1 do
    if effects[i].recipe == "nutrients-from-spoilage" or effects[i].recipe == "spoilage-recycling" then
      table.remove(effects, i)
    end
  end
end
