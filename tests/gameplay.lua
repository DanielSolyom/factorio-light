local function spawn(surface, name, x, y, extra)
  local args = {name = name, position = {x, y}, force = "player"}
  for k, v in pairs(extra or {}) do args[k] = v end
  return assert(surface.create_entity(args), name)
end

script.on_init(function()
  local force = game.forces.player
  force.research_all_technologies()
  local platform = assert(force.create_space_platform{
    name = "QA", planet = "nauvis", starter_pack = "space-platform-starter-pack"})
  platform.apply_starter_pack()
  local surface = platform.surface
  local tiles = {}
  for x = -60, 60 do for y = -60, 60 do
    tiles[#tiles+1] = {name = "space-platform-foundation", position = {x, y}}
  end end
  surface.set_tiles(tiles)
  storage.powered, storage.loaders = {}, {}
  for i, name in ipairs({"steel-chest"}) do
    assert(surface.can_place_entity{name = name, position = {20 + i*2, 20}, force = force})
    local chest = spawn(surface, name, 20+i*2, 20)
    assert(chest.insert{name = "iron-plate", count = 100} == 100)
  end
  for _, name in ipairs({"wooden-chest", "iron-chest", "active-provider-chest", "passive-provider-chest", "storage-chest",
    "buffer-chest", "requester-chest"}) do
    assert(not surface.can_place_entity{name = name, position = {40, 40}, force = force}, name)
  end
  for _, name in ipairs({"roboport", "straight-rail", "half-diagonal-rail", "curved-rail-a",
    "curved-rail-b", "rail-ramp", "rail-support", "elevated-straight-rail",
    "elevated-half-diagonal-rail", "elevated-curved-rail-a", "elevated-curved-rail-b",
    "locomotive", "cargo-wagon", "fluid-wagon", "artillery-wagon", "train-stop",
    "rail-signal", "rail-chain-signal"}) do
    assert(not surface.can_place_entity{name = name, position = {40, 40}, force = force}, name)
  end
  for i, suffix in ipairs({"loader", "fast-loader", "express-loader", "turbo-loader"}) do
    local y = 25 + i*3
    local source = spawn(surface, "steel-chest", 0, y)
    local output = spawn(surface, "factorio-light-" .. suffix, 1, y, {direction = defines.direction.east})
    output.loader_type = "output"
    spawn(surface, "transport-belt", 2, y, {direction = defines.direction.east})
    local input = spawn(surface, "factorio-light-" .. suffix, 3, y, {direction = defines.direction.east})
    input.loader_type = "input"
    input.direction = defines.direction.east
    local target = spawn(surface, "steel-chest", 4, y)
    source.insert{name = "iron-plate", count = 100}
    storage.powered[#storage.powered+1] = output
    storage.powered[#storage.powered+1] = input
    storage.loaders[#storage.loaders+1] = {source = source, target = target}
  end

  storage.barrels = {}
  local i = 0
  for name, recipe in pairs(prototypes.recipe) do
    if name:sub(-7) == "-barrel" and name:sub(1,6) ~= "empty-" then
      local fluid
      for _, ingredient in pairs(recipe.ingredients) do
        if ingredient.type == "fluid" then fluid = ingredient end
      end
      if fluid then
        i = i + 1
        local x, y = -55 + (i%10)*5, -55 + math.floor(i/10)*8
        local fill = spawn(surface, "assembling-machine-3", x, y)
        fill.set_recipe(name)
        assert(fill.get_recipe().name == name, name)
        fill.insert{name = "barrel", count = 1}
        fill.insert_fluid{name = fluid.name, amount = 50, temperature = (fluid.temperature or fluid.minimum_temperature)}
        local empty = spawn(surface, "assembling-machine-3", x, y+4)
        empty.set_recipe("empty-" .. name)
        storage.barrels[#storage.barrels+1] = {fill = fill, empty = empty, item = name,
          fluid = fluid.name, temperature = (fluid.temperature or fluid.minimum_temperature)}
        storage.powered[#storage.powered+1] = fill
        storage.powered[#storage.powered+1] = empty
      end
    end
  end

  local gleba = game.create_surface("qa-gleba", {width = 128, height = 128})
  gleba.set_property("pressure", 2000)
  gleba.request_to_generate_chunks({0,0}, 2)
  gleba.force_generate_chunk_requests()
  local ground = {}
  for x = -40, 40 do for y = -40, 40 do ground[#ground+1] = {name = "landfill", position = {x,y}} end end
  gleba.set_tiles(ground)
  local nutrients = spawn(gleba, "assembling-machine-2", 0, 0)
  nutrients.set_recipe("nutrients-from-yumako-mash")
  nutrients.insert{name = "yumako-mash", count = 4}
  storage.nutrients = nutrients
  storage.powered[#storage.powered+1] = nutrients
  storage.incubation, storage.isolation = {}, {}
  for j, metal in ipairs({"iron", "copper"}) do
    local incubator = spawn(gleba, "biochamber", j*8, 0)
    incubator.set_recipe(metal .. "-bacteria-cultivation")
    incubator.get_inventory(defines.inventory.crafter_input).insert{name = metal .. "-bacteria", count = 1}
    incubator.get_inventory(defines.inventory.crafter_input).insert{name = "bioflux", count = 1}
    incubator.get_fuel_inventory().insert{name = "nutrients", count = 100}
    storage.incubation[#storage.incubation+1] = {entity = incubator, item = metal .. "-bacteria"}
    local isolation = spawn(gleba, "biochamber", j*8, 8)
    isolation.set_recipe("factorio-light-" .. metal .. "-isolation")
    isolation.get_inventory(defines.inventory.crafter_input).insert{name = metal .. "-bacteria", count = 10}
    isolation.get_fuel_inventory().insert{name = "nutrients", count = 100}
    storage.isolation[#storage.isolation+1] = {entity = isolation, item = metal .. "-ore"}
  end
  local chest = spawn(surface, "steel-chest", 10, 20)
  storage.stable = chest
  for _, name in ipairs({"iron-bacteria", "copper-bacteria", "pentapod-egg", "biter-egg", "nutrients", "agricultural-science-pack"}) do
    chest.insert{name = name, count = 1}
  end
end)

script.on_event(defines.events.on_tick, function(event)
  for _, entity in ipairs(storage.powered) do entity.energy = 100000000 end
  if event.tick == 300 then
    for _, test in ipairs(storage.barrels) do
      assert(test.fill.get_output_inventory().get_item_count(test.item) == 1, "fill " .. test.item)
      test.fill.get_output_inventory().remove{name = test.item, count = 1}
      test.empty.insert{name = test.item, count = 1}
    end
  end
  if event.tick ~= 3600 then return end
  for _, test in ipairs(storage.barrels) do
    assert(test.empty.get_output_inventory().get_item_count("barrel") == 1, "empty " .. test.item)
    local fluid
    for i = 1, test.empty.fluids_count do
      local candidate = test.empty.get_fluid(i)
      if candidate and candidate.name == test.fluid then fluid = candidate end
    end
    assert(fluid and math.abs(fluid.amount - 50) < .001, "volume " .. test.item)
    assert(math.abs(fluid.temperature - test.temperature) < .001, "temperature " .. test.item)
  end
  for _, test in ipairs(storage.loaders) do
    assert(test.target.get_item_count("iron-plate") == 100, "loader target " .. test.target.position.y .. " count " .. test.target.get_item_count("iron-plate") .. " source " .. test.source.get_item_count("iron-plate"))
    assert(test.source.get_item_count("iron-plate") == 0)
  end
  assert(storage.nutrients.get_output_inventory().get_item_count("nutrients") == 6)
  for _, test in ipairs(storage.incubation) do
    -- One craft produces four. The 50% inherent productivity bar is half full.
    assert(test.entity.get_output_inventory().get_item_count(test.item) == 4, test.item)
  end
  for _, test in ipairs(storage.isolation) do
    assert(test.entity.get_output_inventory().get_item_count(test.item) == 10, test.item)
  end
  for _, name in ipairs({"iron-bacteria", "copper-bacteria", "pentapod-egg", "biter-egg", "nutrients", "agricultural-science-pack"}) do
    assert(storage.stable.get_item_count(name) == 1, "spoiled " .. name)
  end
  log("FACTORIO LIGHT GAMEPLAY PASSED")
end)
