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
  elseif event.tick == 2400 then
    assert(#storage.cases == 64)
    for index, case in ipairs(storage.cases) do
      assert(case.source.get_item_count("iron-plate") == 0, "source not emptied: " .. index)
      local count = case.result.get_item_count(case.item)
      assert(count == case.count, "transfer " .. index .. ": expected " .. case.count .. ", got " .. count)
    end
    log("FACTORIO LIGHT LOADER PLACEMENT PASSED")
    script.finish_test(true)
  end
end)
