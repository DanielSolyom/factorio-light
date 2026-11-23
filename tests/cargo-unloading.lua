-- Real engine transfers beyond 59 tiles, on planets and platforms. Construction
-- events exercise the shipped mod, including disconnected/removed/rebuilt bays.
local directions = {
  {defines.direction.north, 0, -1}, {defines.direction.east, 1, 0},
  {defines.direction.south, 0, 1}, {defines.direction.west, -1, 0}
}
local tiers = {"loader", "fast-loader", "express-loader", "turbo-loader"}
local proxy_name = "factorio-light-cargo-bay-output"

local function spawn(surface, name, position, extra)
  local args = {name = name, position = position, force = "player", raise_built = true}
  for key, value in pairs(extra or {}) do args[key] = value end
  return assert(surface.create_entity(args), name)
end

local function setup(platform, direction, tier)
  local surface, hub
  local name = (platform and "orbit-" or "ground-") .. tier
  if platform then
    local p = game.forces.player.create_space_platform{
      name = name, planet = "nauvis", starter_pack = "space-platform-starter-pack"}
    hub = p.apply_starter_pack()
    surface = p.surface
  else
    surface = game.create_surface(name, {width = 320, height = 320})
    surface.request_to_generate_chunks({0, 0}, 5)
    surface.force_generate_chunk_requests()
    for _, entity in pairs(surface.find_entities()) do entity.destroy() end
  end
  local function pos(distance, side)
    return {direction[2]*distance - direction[3]*(side or 0),
      direction[3]*distance + direction[2]*(side or 0)}
  end
  local tiles = {}
  for distance = -10, 140 do for side = -10, 10 do
    tiles[#tiles+1] = {name = platform and "space-platform-foundation" or "landfill",
      position = pos(distance, side)}
  end end
  surface.set_tiles(tiles)
  if not platform then hub = spawn(surface, "cargo-landing-pad", {0, 0}) end
  local bays = {}
  for distance = 6, 126, 4 do
    bays[#bays+1] = spawn(surface, "cargo-bay", pos(distance))
  end
  local bay = bays[#bays]
  assert(bay.cargo_bay_connection_owner == hub, name .. " disconnected")
  assert(hub.insert{name = "iron-plate", count = 1000} == 1000)
  local chest = spawn(surface, "steel-chest", pos(129.5, -1.5))
  local arm = spawn(surface, "inserter", pos(128.5, -1.5),
    {direction = (direction[1] + 8) % 16})
  local input = spawn(surface, "steel-chest", pos(129.5, -.5))
  input.insert{name = "copper-plate", count = 100}
  local input_arm = spawn(surface, "inserter", pos(128.5, -.5), {direction = direction[1]})
  local result = spawn(surface, "steel-chest", pos(131.5, .5))
  spawn(surface, "transport-belt", pos(129.5, .5), {direction = direction[1]})
  local output = spawn(surface, "factorio-light-" .. tier, pos(128.5, .5), {direction = direction[1]})
  local loader = spawn(surface, "factorio-light-" .. tier, pos(130.5, .5), {direction = direction[1]})
  output.set_filter(1, "iron-plate")
  for _, entity in ipairs({arm, input_arm, output, loader}) do
    storage.powered[#storage.powered+1] = entity
  end
  return {platform = platform, surface = surface, hub = hub, bays = bays, bay = bay,
    chest = chest, input = input, result = result, arm = arm, output = output,
    bridge_position = pos(62), direction = direction[1]}
end

script.on_event(defines.events.on_tick, function(event)
  if event.tick == 1 then
    storage.powered, storage.cases = {}, {}
    for _, platform in ipairs({false, true}) do
      for i, direction in ipairs(directions) do
        storage.cases[#storage.cases+1] = setup(platform, direction, tiers[i])
      end
    end
  end
  for _, entity in ipairs(storage.powered or {}) do
    if entity.valid then entity.energy = 1e8 end
  end
  if event.tick == 300 then
    for _, case in ipairs(storage.cases) do
      assert(case.chest.get_item_count("iron-plate") > 0, "inserter failed: " .. case.surface.name)
      assert(case.result.get_item_count("iron-plate") > 0, "loader failed: " .. case.surface.name ..
        " " .. case.output.loader_type .. " " .. tostring(case.output.direction) ..
        " " .. tostring(case.output.loader_container))
      assert(case.hub.get_item_count("copper-plate") == 0, "bay must remain output-only")
      local total = case.hub.get_item_count("iron-plate")
      for _, chest in pairs(case.surface.find_entities_filtered{type = "container"}) do
        total = total + chest.get_item_count("iron-plate")
      end
      for _, arm in pairs(case.surface.find_entities_filtered{type = "inserter"}) do
        if arm.held_stack.valid_for_read and arm.held_stack.name == "iron-plate" then
          total = total + arm.held_stack.count
        end
      end
      for _, belt in pairs(case.surface.find_entities_filtered{type = {"transport-belt", "loader-1x1"}}) do
        for line = 1, 2 do total = total + belt.get_transport_line(line).get_item_count("iron-plate") end
      end
      assert(total == 1000, "cargo was lost or duplicated: " .. total)
      -- A bridge removed without a raised event must also be detected.
      case.bays[15].destroy()
    end
  elseif event.tick == 310 then
    for _, case in ipairs(storage.cases) do
      assert(not case.bay.cargo_bay_connection_owner)
      if case.platform then
        assert(not case.surface.find_entity(proxy_name, case.bay.position), "detached proxy survived")
      end
      case.remaining = case.hub.get_item_count("iron-plate")
    end
  elseif event.tick == 400 then
    for _, case in ipairs(storage.cases) do
      assert(case.hub.get_item_count("iron-plate") == case.remaining, "detached bay still unloaded")
      -- Revived blueprint construction reconnects the complete tail.
      local ghost = spawn(case.surface, "entity-ghost", case.bridge_position, {inner_name = "cargo-bay"})
      local _, revived = ghost.revive{raise_revive = true}
      assert(revived)
    end
  elseif event.tick == 550 then
    for _, case in ipairs(storage.cases) do
      assert(case.hub.get_item_count("iron-plate") < case.remaining, "revived chain did not unload")
      if case.platform then
        -- Clone and script-raised removal must not leave helpers behind.
        local p = {case.bay.position.x + 12, case.bay.position.y + 12}
        local clone = assert(case.bay.clone{position = p})
        assert(not case.surface.find_entity(proxy_name, p), "detached clone got inventory access")
        clone.destroy{raise_destroy = true}
      end
      case.bay.destroy{raise_destroy = true}
    end
  elseif event.tick == 560 then
    for _, case in ipairs(storage.cases) do
      if case.platform then
        for _, proxy in pairs(case.surface.find_entities_filtered{name = proxy_name}) do
          local bay = assert(case.surface.find_entity("cargo-bay", proxy.position), "orphan proxy")
          assert(proxy.proxy_target_entity == bay.cargo_bay_connection_owner)
        end
      end
    end
    log("FACTORIO LIGHT CARGO UNLOADING PASSED")
  end
end)
