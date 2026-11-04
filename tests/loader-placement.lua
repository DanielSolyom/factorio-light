-- Exercise real player construction, native electricity, and actual transfers.
-- Do not set loader_type or direction after construction: that hid this bug.
local tiers = {
  {"loader", "transport-belt"}, {"fast-loader", "fast-transport-belt"},
  {"express-loader", "express-transport-belt"}, {"turbo-loader", "turbo-transport-belt"}
}
local directions = {
  {defines.direction.north, 0, -1}, {defines.direction.east, 1, 0},
  {defines.direction.south, 0, 1}, {defines.direction.west, -1, 0}
}
local placement = require("__factorio-light-space-age__/scripts/loader-placement")

script.on_event(defines.events.on_tick, function(event)
  if event.tick == 1 then
    local player = assert(game.get_player(1))
    player.set_controller{type = defines.controllers.god}
    local surface = player.surface
    surface.request_to_generate_chunks({0, 0}, 4)
    surface.force_generate_chunk_requests()
    for _, entity in pairs(surface.find_entities_filtered{area = {{-90, -90}, {90, 90}},
      type = {"tree", "simple-entity", "cliff"}}) do entity.destroy() end
    local tiles = {}
    for x = -90, 90 do for y = -90, 90 do
      tiles[#tiles+1] = {name = "landfill", position = {x, y}}
    end end
    surface.set_tiles(tiles)
    player.force.research_all_technologies()
    storage.cases = {}
    for _, tier in ipairs(tiers) do
      for _, direction in ipairs(directions) do
        for _, machine in ipairs({false, true}) do
          for _, reverse_cursor in ipairs({false, true}) do
            local index = #storage.cases
            local cx, cy = -70 + (index % 8)*20 + .5, -70 + math.floor(index/8)*20 + .5
            local function position(distance, side)
              return {cx + direction[2]*distance - direction[3]*(side or 0),
                cy + direction[3]*distance + direction[2]*(side or 0)}
            end
            local function create(name, distance, side, extra)
              local args = {name = name, position = position(distance, side), force = player.force}
              for key, value in pairs(extra or {}) do args[key] = value end
              return assert(surface.create_entity(args), name)
            end
            local function place(distance)
              assert(player.cursor_stack.set_stack{name = "factorio-light-" .. tier[1], count = 1})
              player.teleport(position(distance, 3))
              player.build_from_cursor{position = position(distance),
                direction = (direction[1] + (reverse_cursor and 8 or 0)) % 16}
              local loader = assert(surface.find_entity("factorio-light-" .. tier[1], position(distance)))
              loader.update_connections()
              assert(loader.loader_container, "placed loader has no container: " .. index .. "/" .. distance)
              assert(loader.direction == direction[1], "placement must follow belt flow")
              return loader
            end
            create("electric-energy-interface", 0, 8)
            create("substation", 0, 5)
            local source = create("steel-chest", -6)
            source.insert{name = "iron-plate", count = 40}
            local target = create(machine and "assembling-machine-3" or "steel-chest", 0)
            local result = target
            if machine then
              target.set_recipe("iron-gear-wheel")
              result = create("steel-chest", 5)
              create(tier[2], 3, 0, {direction = direction[1]})
              place(2)
              place(4)
            end
            for distance = -4, (machine and -3 or -2) do
              create(tier[2], distance, 0, {direction = direction[1]})
            end
            local output = place(-5)
            local input = place(machine and -2 or -1)
            assert(output.loader_type == "output" and input.loader_type == "input")
            -- R must still reverse a connected loader, and reverse it back.
            assert(input.rotate{by_player = player})
            input.update_connections()
            assert(input.loader_type == "output" and input.loader_container == target,
              "rotated input: " .. input.loader_type .. "/" .. tostring(input.loader_container))
            assert(input.rotate{by_player = player})
            input.update_connections()
            assert(input.loader_type == "input" and input.loader_container == target)
            -- Reproduce old-save disconnected loaders without a construction event.
            -- Keep half the cases connected, to check that repair leaves them alone.
            input.set_filter(1, "iron-plate")
            input.loader_belt_stack_size_override = 2
            if reverse_cursor then
              input.loader_type = "output"
              input.direction = direction[1]
              input.update_connections()
              assert(not input.loader_container)
            end
            storage.cases[#storage.cases+1] = {source = source, result = result,
              input = input, target = target, direction = direction[1],
              item = machine and "iron-gear-wheel" or "iron-plate", count = machine and 20 or 40}
          end
        end
      end
    end
    placement.repair()
    placement.repair() -- Repeating an update must not reverse a repaired loader.
    for _, case in ipairs(storage.cases) do
      assert(case.input.loader_type == "input" and case.input.direction == case.direction)
      assert(case.input.loader_container == case.target)
      assert(case.input.get_filter(1).name == "iron-plate")
      assert(case.input.loader_belt_stack_size_override == 2)
    end
    -- Dedicated loader mods also handle belt ghosts and perpendicular outputs.
    surface = game.create_surface("loader-edges", {width = 200, height = 200})
    surface.request_to_generate_chunks({0, 0}, 4)
    surface.force_generate_chunk_requests()
    for _, entity in pairs(surface.find_entities_filtered{type = {"tree", "simple-entity", "cliff"}}) do
      entity.destroy()
    end
    surface.set_tiles(tiles)
    player.teleport({0, 0}, surface)
    storage.edges = {}
    for _, direction in ipairs(directions) do
      for kind = 1, 3 do
        local index = #storage.edges
        local cx, cy = -70 + (index % 8)*20 + .5, -80 + math.floor(index/8)*20 + .5
        local function pos(distance)
          return {cx + direction[2]*distance, cy + direction[3]*distance}
        end
        for _, power in ipairs({{"substation", 5}, {"electric-energy-interface", 8}}) do
          assert(surface.create_entity{name = power[1], force = player.force,
            position = {cx - direction[3]*power[2], cy + direction[2]*power[2]}})
        end
        local sideways = kind > 1
        local belt_direction = (direction[1] + (sideways and 4 or 0)) % 16
        local belt_position = pos(sideways and 1 or -1)
        local belt = assert(surface.create_entity{
          name = kind == 2 and "transport-belt" or "entity-ghost",
          inner_name = kind ~= 2 and "transport-belt" or nil,
          position = belt_position, direction = belt_direction, force = player.force})
        local chest
        if sideways then
          chest = assert(surface.create_entity{name = "steel-chest", position = pos(-1), force = player.force})
          chest.insert{name = "iron-plate", count = 20}
        end
        local loader
        if kind == 1 then
          -- Belt first, machine later; raised build must see the ghost belt.
          loader = assert(surface.create_entity{name = "factorio-light-loader",
            position = pos(0), direction = direction[1], force = player.force, raise_built = true})
          chest = assert(surface.create_entity{name = "steel-chest", position = pos(1), force = player.force})
        elseif kind == 2 then
          player.cursor_stack.set_stack{name = "factorio-light-loader", count = 1}
          player.teleport(pos(3))
          player.build_from_cursor{position = pos(0), direction = (direction[1] + 8) % 16}
          loader = assert(surface.find_entity("factorio-light-loader", pos(0)))
        else
          local ghost = assert(surface.create_entity{name = "entity-ghost", inner_name = "factorio-light-loader",
            position = pos(0), direction = (direction[1] + 8) % 16, force = player.force})
          local _, revived = ghost.revive{raise_revive = true}
          loader = assert(revived)
        end
        loader.update_connections()
        assert(loader.loader_container == chest, "edge container " .. index)
        assert(loader.loader_type == (sideways and "output" or "input"), "edge mode " .. index)
        assert(loader.direction == direction[1], "edge flow " .. index)
        if belt.type == "entity-ghost" then
          local _, revived = belt.revive{raise_revive = true}
          belt = assert(revived)
        end
        if not sideways then
          assert(belt.get_transport_line(1).insert_at_back{name = "iron-plate", count = 1})
        end
        storage.edges[#storage.edges+1] = {chest = chest, belt = belt, sideways = sideways}
      end
    end
  elseif event.tick == 2400 then
    assert(#storage.cases == 64)
    for index, case in ipairs(storage.cases) do
      assert(case.source.get_item_count("iron-plate") == 0, "source not emptied: " .. index)
      local count = case.result.get_item_count(case.item)
      assert(count == case.count, "transfer " .. index .. ": expected " .. case.count .. ", got " .. count)
    end
    for index, case in ipairs(storage.edges) do
      if case.sideways then
        assert(case.chest.get_item_count("iron-plate") < 20, "side-loading source " .. index)
        assert(case.belt.get_transport_line(1).get_item_count("iron-plate")
          + case.belt.get_transport_line(2).get_item_count("iron-plate") > 0, "side-loading belt " .. index)
      else
        assert(case.chest.get_item_count("iron-plate") == 1, "ghost belt loading " .. index)
      end
    end
    log("FACTORIO LIGHT LOADER PLACEMENT PASSED")
    script.finish_test(true)
  end
end)
