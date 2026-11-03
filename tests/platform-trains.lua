-- Exercise native platform placement, rolling stock coupling, fuel and schedules.
local function place(surface, name, x, y, direction)
  local args = {name = name, position = {x, y}, direction = direction or defines.direction.north,
    force = game.forces.player}
  assert(surface.can_place_entity(args), "cannot place " .. name .. " at " .. x .. "," .. y)
  return assert(surface.create_entity(args), name)
end

script.on_init(function()
  local platform = game.forces.player.create_space_platform{
    name = "Railway QA", planet = "nauvis", starter_pack = "space-platform-starter-pack"}
  platform.apply_starter_pack()
  local surface = platform.surface
  local tiles = {}
  for x = 10, 80 do for y = -70, 70 do
    tiles[#tiles+1] = {name = "space-platform-foundation", position = {x,y}}
  end end
  surface.set_tiles(tiles)
  for y = -60, 60, 2 do place(surface, "straight-rail", 20, y) end
  local north = place(surface, "train-stop", 22, -46)
  local south = place(surface, "train-stop", 18, 46, defines.direction.south)
  assert(north.connected_rail and south.connected_rail, "stops must connect to the track")
  north.backer_name, south.backer_name = "North", "South"
  local engine = place(surface, "locomotive", 20, -7)
  local cargo = place(surface, "cargo-wagon", 20, 0)
  local fluid = place(surface, "fluid-wagon", 20, 7)
  local artillery = place(surface, "artillery-wagon", 20, 14)
  local reverse = place(surface, "locomotive", 20, 21, defines.direction.south)
  assert(#engine.train.carriages == 5, "all rolling stock must couple")
  engine.insert{name = "coal", count = 50}
  reverse.insert{name = "coal", count = 50}
  assert(cargo.insert{name = "iron-plate", count = 100} == 100)
  assert(fluid.insert_fluid{name = "water", amount = 1000} == 1000)
  assert(artillery.insert{name = "artillery-shell", count = 1} == 1)
  engine.train.schedule = {current = 1, records = {
    {station = "North", wait_conditions = {{type = "time", compare_type = "and", ticks = 60}}},
    {station = "South", wait_conditions = {{type = "time", compare_type = "and", ticks = 60}}}}}
  engine.train.manual_mode = false
  -- Separate track for native signal placement, without changing the shuttle blocks.
  for y = -10, 10, 2 do place(surface, "straight-rail", 40, y) end
  for index, name in ipairs({"rail-signal", "rail-chain-signal"}) do
    local placed
    for y = index*4 - 12, index*4 - 9 do
      for _, x in ipairs({38.5, 41.5}) do
        for _, direction in ipairs({defines.direction.north, defines.direction.south}) do
          local args = {name = name, position = {x, y+.5}, direction = direction, force = game.forces.player}
          if not placed and surface.can_place_entity(args) then
            placed = assert(surface.create_entity(args))
          end
        end
      end
    end
    assert(placed, "no legal platform signal placement: " .. name)
  end
  place(surface, "rail-ramp", 60, 0)
  for y = -10, -16, -2 do place(surface, "elevated-straight-rail", 60, y) end
  -- Rails snap to odd X coordinates; supports must share the track centre.
  place(surface, "rail-support", 61, -16)
  for y = -18, -24, -2 do place(surface, "elevated-straight-rail", 60, y) end
  storage.engine, storage.reverse = engine, reverse
  storage.cargo, storage.fluid = cargo, fluid
  storage.visited = {}
  storage.moved = false
end)

script.on_event(defines.events.on_tick, function(event)
  local train = storage.engine.train
  if math.abs(train.speed) > .01 then storage.moved = true end
  if train.station then storage.visited[train.station.backer_name] = true end
  if event.tick ~= 3600 then return end
  assert(storage.moved, "platform train never moved")
  assert(storage.visited.North and storage.visited.South, "train must visit both scheduled stops")
  assert(storage.engine.get_fuel_inventory().get_item_count("coal") < 50, "northbound locomotive used no fuel")
  assert(storage.reverse.get_fuel_inventory().get_item_count("coal") < 50, "southbound locomotive used no fuel")
  assert(storage.cargo.get_item_count("iron-plate") == 100)
  assert(storage.fluid.get_fluid_count("water") == 1000)
  log("FACTORIO LIGHT PLATFORM TRAINS PASSED")
end)
