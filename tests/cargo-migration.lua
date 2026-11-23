-- Created with the old entity/item names, then loaded with the new package.
script.on_init(function()
  storage.cases = {}
  for i, direction in ipairs({0, 4, 8, 12}) do
    local surface = game.create_surface("migration-" .. i, {width = 64, height = 64})
    surface.request_to_generate_chunks({0, 0}, 1)
    surface.force_generate_chunk_requests()
    for _, entity in pairs(surface.find_entities()) do entity.destroy() end
    local tiles = {}
    for x = -20, 20 do for y = -20, 20 do
      tiles[#tiles+1] = {name = "landfill", position = {x,y}}
    end end
    surface.set_tiles(tiles)
    local function create(name, position, extra)
      local args = {name = name, position = position, force = "player"}
      for k, v in pairs(extra or {}) do args[k] = v end
      return assert(surface.create_entity(args))
    end
    local hub = create("cargo-landing-pad", {0, 0})
    local bay = create("landing-pad-unloading-bay", {6, 0}, {direction = direction})
    local ghost = create("entity-ghost", {12, 0}, {inner_name = "landing-pad-unloading-bay", direction = direction})
    local chest = create("steel-chest", {16.5, .5})
    chest.insert{name = "landing-pad-unloading-bay", count = 3}
    local blueprint = chest.get_inventory(defines.inventory.chest)[2]
    blueprint.set_stack{name = "blueprint"}
    blueprint.set_blueprint_entities{{entity_number = 1, name = "landing-pad-unloading-bay",
      position = {0, 0}, direction = direction}}
    assert(hub.insert{name = "iron-plate", count = 123} == 123)
    storage.cases[#storage.cases+1] = {hub = hub, bay = bay, ghost = ghost, chest = chest, unit = bay.unit_number}
  end
  local platform = game.forces.player.create_space_platform{
    name = "Existing platform", planet = "nauvis", starter_pack = "space-platform-starter-pack"}
  local hub = platform.apply_starter_pack()
  local tiles = {}
  for x = -10, 15 do for y = -10, 10 do
    tiles[#tiles+1] = {name = "space-platform-foundation", position = {x,y}}
  end end
  platform.surface.set_tiles(tiles)
  storage.platform_bay = assert(platform.surface.create_entity{name = "cargo-bay", position = {6, 0}, force = "player"})
  storage.hub = hub
  hub.insert{name = "iron-plate", count = 123}
end)

script.on_event(defines.events.on_tick, function(event)
  if event.tick ~= 1 then return end
  assert(not prototypes.entity["landing-pad-unloading-bay"])
  assert(not prototypes.item["landing-pad-unloading-bay"])
  for _, case in ipairs(storage.cases) do
    assert(case.bay.valid and case.bay.name == "cargo-bay" and case.bay.unit_number == case.unit)
    assert(case.bay.cargo_bay_connection_owner == case.hub)
    assert(case.ghost.valid and case.ghost.ghost_name == "cargo-bay")
    assert(case.chest.get_item_count("cargo-bay") == 3)
    assert(case.chest.get_inventory(defines.inventory.chest)[2].get_blueprint_entities()[1].name == "cargo-bay")
    assert(case.hub.get_item_count("iron-plate") == 123)
  end
  local proxy = assert(storage.hub.surface.find_entity("factorio-light-cargo-bay-output", storage.platform_bay.position))
  assert(proxy.proxy_target_entity == storage.hub)
  assert(storage.hub.get_item_count("iron-plate") == 123)
  log("FACTORIO LIGHT CARGO MIGRATION PASSED")
end)
