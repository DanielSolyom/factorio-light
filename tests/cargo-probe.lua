-- Regression fixture only. A separate QA mod enables allow_unloading on cargo-bay.
script.on_init(function()
  storage.arms, storage.cases = {}, {}
  for i, target in ipairs({"hub", "bay"}) do
    for _, direction in ipairs({"out", "in"}) do
      local platform = game.forces.player.create_space_platform{
        name = target .. direction, planet = "nauvis", starter_pack = "space-platform-starter-pack"}
      local hub = platform.apply_starter_pack()
      local surface = platform.surface
      local tiles = {}
      for x = -20, 20 do for y = -20, 20 do
        tiles[#tiles+1] = {name = "space-platform-foundation", position = {x,y}}
      end end
      surface.set_tiles(tiles)
      local x = 4.5
      if target == "bay" then
        local bay = surface.create_entity{name = "cargo-bay", position = {6,0}, force = "player"}
        assert(bay)
        x = 8.5
      end
      local chest = surface.create_entity{name = "steel-chest", position = {x+1,.5}, force = "player"}
      local arm = surface.create_entity{name = "inserter", position = {x,.5}, force = "player",
        direction = direction == "out" and defines.direction.west or defines.direction.east}
      if direction == "out" then hub.insert{name = "iron-plate", count = 100}
      else chest.insert{name = "iron-plate", count = 100} end
      storage.arms[#storage.arms+1] = arm
      storage.cases[#storage.cases+1] = {name = target .. "-" .. direction, hub = hub, chest = chest}
    end
  end
end)
script.on_event(defines.events.on_tick, function(event)
  for _, arm in ipairs(storage.arms) do arm.energy = 1e6 end
  if event.tick ~= 600 then return end
  local results = {}
  for _, case in ipairs(storage.cases) do
    results[case.name] = {hub = case.hub.get_item_count("iron-plate"), chest = case.chest.get_item_count("iron-plate")}
  end
  helpers.write_file("cargo-probe.json", helpers.table_to_json(results))
end)
