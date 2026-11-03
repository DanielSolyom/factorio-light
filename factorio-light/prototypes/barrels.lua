-- Vanilla generates these barrels in base/data-updates.lua, after our data.lua.
-- Explicit additions cover every real 2.1 fluid; blueprint parameters are excluded.
data.raw.fluid["ammoniacal-solution"].auto_barrel = true
data.raw.fluid.ammonia.auto_barrel = true
data.raw.fluid.fluorine.auto_barrel = true
data.raw.fluid["holmium-solution"].auto_barrel = true
data.raw.fluid.electrolyte.auto_barrel = true
data.raw.fluid["lithium-brine"].auto_barrel = true
data.raw.fluid.lava.auto_barrel = true
data.raw.fluid["molten-iron"].auto_barrel = true
data.raw.fluid["molten-copper"].auto_barrel = true
data.raw.fluid["thruster-fuel"].auto_barrel = true
data.raw.fluid["thruster-oxidizer"].auto_barrel = true

-- An item cannot remember an arbitrary fluid temperature. Each hot barrel is
-- therefore a separate item and accepts ONLY its labelled temperature.
local function hot_barrel(fluid, temperature)
  local name = "factorio-light-" .. fluid .. "-" .. temperature .. "-barrel"
  local icons = {
    {icon = "__base__/graphics/icons/fluid/barreling/empty-barrel.png", icon_size = 64},
    {icon = data.raw.fluid[fluid].icon, icon_size = 64, scale = 0.4}
  }
  local label = {"fluid-name." .. fluid}
  data:extend({
    {type = "item", name = name, icons = icons,
      localised_name = {"item-name.factorio-light-hot-barrel", label, tostring(temperature)},
      subgroup = "barrel", order = "z-" .. fluid .. "-" .. temperature,
      stack_size = 10, weight = 10000, auto_recycle = false},
    {type = "recipe", name = name, icons = icons,
      localised_name = {"recipe-name.factorio-light-fill-hot-barrel", label, tostring(temperature)},
      categories = {"crafting-with-fluid"}, subgroup = "fill-barrel",
      enabled = false, energy_required = 0.2, allow_productivity = false,
      allow_quality = false, auto_recycle = false, allow_decomposition = false,
      ingredients = {{type = "item", name = "barrel", amount = 1},
        {type = "fluid", name = fluid, amount = 50,
          minimum_temperature = temperature, maximum_temperature = temperature}},
      results = {{type = "item", name = name, amount = 1}}},
    {type = "recipe", name = "empty-" .. name, icons = icons,
      localised_name = {"recipe-name.factorio-light-empty-hot-barrel", label, tostring(temperature)},
      categories = {"crafting-with-fluid"}, subgroup = "empty-barrel",
      enabled = false, energy_required = 0.2, allow_productivity = false,
      allow_quality = false, auto_recycle = false, allow_decomposition = false,
      ingredients = {{type = "item", name = name, amount = 1}},
      results = {{type = "item", name = "barrel", amount = 1},
        {type = "fluid", name = fluid, amount = 50, temperature = temperature}}}
  })
  for _, recipe in ipairs({name, "empty-" .. name}) do
    table.insert(data.raw.technology["fluid-handling"].effects, {type = "unlock-recipe", recipe = recipe})
  end
end
hot_barrel("steam", 15)
hot_barrel("steam", 165)
hot_barrel("steam", 500)
for temperature = 1000000, 10000000, 1000000 do hot_barrel("fusion-plasma", temperature) end

-- Native plasma ports otherwise connect only to fusion machinery. Assemblers
-- can fill/empty plasma barrels when directly adjacent to those ports.
for _, name in ipairs({"assembling-machine-2", "assembling-machine-3"}) do
  for _, box in ipairs(data.raw["assembling-machine"][name].fluid_boxes) do
    for _, connection in ipairs(box.pipe_connections) do
      connection.connection_category = {"default", "fusion-reactor"}
    end
  end
end
