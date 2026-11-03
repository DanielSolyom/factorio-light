-- Independent engine reference: run unchanged in Quality and Factorio Light profiles.
script.on_init(function()
  local result = {}
  local quality = script.active_mods.quality and "legendary" or "normal"
  result.entity = {}
  for name, prototype in pairs(prototypes.entity) do
    local values = {type = prototype.type}
    do local ok, value = pcall(function() return prototype.get_attraction_range_elongation(quality) end); if ok and value ~= nil then values.get_attraction_range_elongation = value end end
    do local ok, value = pcall(function() return prototype.get_crafting_speed(quality) end); if ok and value ~= nil then values.get_crafting_speed = value end end
    do local ok, value = pcall(function() return prototype.get_duration(quality) end); if ok and value ~= nil then values.get_duration = value end end
    do local ok, value = pcall(function() return prototype.get_energy_distribution_efficiency(quality) end); if ok and value ~= nil then values.get_energy_distribution_efficiency = value end end
    do local ok, value = pcall(function() return prototype.get_fluid_capacity(quality) end); if ok and value ~= nil then values.get_fluid_capacity = value end end
    do local ok, value = pcall(function() return prototype.get_fluid_usage_per_tick(quality) end); if ok and value ~= nil then values.get_fluid_usage_per_tick = value end end
    do local ok, value = pcall(function() return prototype.get_inserter_extension_speed(quality) end); if ok and value ~= nil then values.get_inserter_extension_speed = value end end
    do local ok, value = pcall(function() return prototype.get_inserter_rotation_speed(quality) end); if ok and value ~= nil then values.get_inserter_rotation_speed = value end end
    do local ok, value = pcall(function() return prototype.get_inventory_size_bonus(quality) end); if ok and value ~= nil then values.get_inventory_size_bonus = value end end
    do local ok, value = pcall(function() return prototype.get_max_circuit_wire_distance(quality) end); if ok and value ~= nil then values.get_max_circuit_wire_distance = value end end
    do local ok, value = pcall(function() return prototype.get_max_distance_of_nearby_sector_revealed(quality) end); if ok and value ~= nil then values.get_max_distance_of_nearby_sector_revealed = value end end
    do local ok, value = pcall(function() return prototype.get_max_distance_of_sector_revealed(quality) end); if ok and value ~= nil then values.get_max_distance_of_sector_revealed = value end end
    do local ok, value = pcall(function() return prototype.get_max_energy(quality) end); if ok and value ~= nil then values.get_max_energy = value end end
    do local ok, value = pcall(function() return prototype.get_max_energy_production(quality) end); if ok and value ~= nil then values.get_max_energy_production = value end end
    do local ok, value = pcall(function() return prototype.get_max_energy_usage(quality) end); if ok and value ~= nil then values.get_max_energy_usage = value end end
    do local ok, value = pcall(function() return prototype.get_max_health(quality) end); if ok and value ~= nil then values.get_max_health = value end end
    do local ok, value = pcall(function() return prototype.get_max_power_output(quality) end); if ok and value ~= nil then values.get_max_power_output = value end end
    do local ok, value = pcall(function() return prototype.get_max_speed(quality) end); if ok and value ~= nil then values.get_max_speed = value end end
    do local ok, value = pcall(function() return prototype.get_max_wire_distance(quality) end); if ok and value ~= nil then values.get_max_wire_distance = value end end
    do local ok, value = pcall(function() return prototype.get_mining_drill_radius(quality) end); if ok and value ~= nil then values.get_mining_drill_radius = value end end
    do local ok, value = pcall(function() return prototype.get_pumping_speed(quality) end); if ok and value ~= nil then values.get_pumping_speed = value end end
    do local ok, value = pcall(function() return prototype.get_researching_speed(quality) end); if ok and value ~= nil then values.get_researching_speed = value end end
    do local ok, value = pcall(function() return prototype.get_supply_area_distance(quality) end); if ok and value ~= nil then values.get_supply_area_distance = value end end
    do local ok, value = pcall(function() return prototype.get_valve_flow_rate(quality) end); if ok and value ~= nil then values.get_valve_flow_rate = value end end
    result.entity[name] = values
  end
  result.equipment = {}
  for name, prototype in pairs(prototypes.equipment) do
    local values = {type = prototype.type}
    do local ok, value = pcall(function() return prototype.get_energy_consumption(quality) end); if ok and value ~= nil then values.get_energy_consumption = value end end
    do local ok, value = pcall(function() return prototype.get_inventory_bonus(quality) end); if ok and value ~= nil then values.get_inventory_bonus = value end end
    do local ok, value = pcall(function() return prototype.get_movement_bonus(quality) end); if ok and value ~= nil then values.get_movement_bonus = value end end
    do local ok, value = pcall(function() return prototype.get_shield(quality) end); if ok and value ~= nil then values.get_shield = value end end
    result.equipment[name] = values
  end
  result.item = {}
  for name, prototype in pairs(prototypes.item) do
    local values = {type = prototype.type}
    do local ok, value = pcall(function() return prototype.get_durability(quality) end); if ok and value ~= nil then values.get_durability = value end end
    do local ok, value = pcall(function() return prototype.get_inventory_size(quality) end); if ok and value ~= nil then values.get_inventory_size = value end end
    do local ok, value = pcall(function() return prototype.get_inventory_size_bonus(quality) end); if ok and value ~= nil then values.get_inventory_size_bonus = value end end
    do local ok, value = pcall(function() return prototype.get_module_effects(quality) end); if ok and value ~= nil then values.get_module_effects = value end end
    do local ok, value = pcall(function() return prototype.get_spoil_ticks(quality) end); if ok and value ~= nil then values.get_spoil_ticks = value end end
    result.item[name] = values
  end
  -- Inventory getters need an inventory index as well as quality.
  for name, prototype in pairs(prototypes.entity) do
    for inventory, index in pairs(defines.inventory) do
      local ok, value = pcall(function() return prototype.get_inventory_size(index, quality) end)
      if ok and value then result.entity[name]["inventory_" .. inventory] = value end
    end
  end
  local inventory = game.create_inventory(1)
  for name, prototype in pairs(prototypes.item) do
    if prototype.type == "armor" and prototype.equipment_grid then
      inventory[1].set_stack{name = name, quality = quality}
      result.item[name].grid_width = inventory[1].grid.width
      result.item[name].grid_height = inventory[1].grid.height
      inventory.clear()
    end
  end
  inventory[1].set_stack{name = "mech-armor", quality = quality}
  local grid = inventory[1].grid
  for name, prototype in pairs(prototypes.equipment) do
    if prototype.type ~= "equipment-ghost" then
    local equipment = assert(grid.put{name = name, position = {0,0}, quality = quality})
    result.equipment[name].max_energy = equipment.max_energy
    result.equipment[name].max_shield = equipment.max_shield
    grid.clear()
    end
  end
  inventory.destroy()
  helpers.write_file("reference.json", helpers.table_to_json(result))
end)
