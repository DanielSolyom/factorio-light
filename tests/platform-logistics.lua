-- All five logistic chest types must work with actual robots and electricity
-- on a real platform. The scenario never moves cargo on the robots' behalf.
local function request(chest, name, count)
  local sections = assert(chest.get_logistic_sections())
  local section = sections.get_section(1) or sections.add_section()
  section.set_slot(1, {value = {type = "item", name = name, quality = "normal", comparator = "="},
    min = count, max = count})
end

script.on_init(function()
  local force = game.forces.player
  force.research_all_technologies()
  local platform = assert(force.create_space_platform{
    name = "Robot logistics", planet = "nauvis", starter_pack = "space-platform-starter-pack"})
  platform.apply_starter_pack()
  platform.hub.request_missing_construction_materials = false
  local surface = platform.surface
  local tiles = {}
  for x = -10, 40 do for y = -20, 20 do
    tiles[#tiles+1] = {name = "space-platform-foundation", position = {x, y}}
  end end
  surface.set_tiles(tiles)
  local function create(name, x, y)
    local args = {name = name, position = {x, y}, force = force}
    assert(surface.can_place_entity(args), "platform placement rejected: " .. name)
    return assert(surface.create_entity(args), name)
  end
  storage.port = create("roboport", 16, 0)
  create("substation", 20, 0)
  storage.power = create("electric-energy-interface", 24, 0)
  storage.passive = create("passive-provider-chest", 8.5, -6.5)
  storage.active = create("active-provider-chest", 8.5, 6.5)
  storage.chest = create("storage-chest", 18.5, 6.5)
  storage.buffer = create("buffer-chest", 20.5, -6.5)
  storage.requester = create("requester-chest", 28.5, -6.5)
  assert(storage.port.get_inventory(defines.inventory.roboport_robot).insert{name = "logistic-robot", count = 10} == 10)
  assert(storage.passive.insert{name = "iron-plate", count = 100} == 100)
  assert(storage.passive.insert{name = "iron-gear-wheel", count = 100} == 100)
  assert(storage.active.insert{name = "copper-plate", count = 100} == 100)
  request(storage.requester, "iron-plate", 100)
  request(storage.buffer, "iron-gear-wheel", 100)
end)

script.on_event(defines.events.on_tick, function(event)
  if event.tick == 3600 then
    assert(storage.port.energy > 0 and storage.port.is_connected_to_electric_network(), "roboport unpowered")
    local network = assert(storage.port.logistic_network, "roboport has no logistic network")
    assert(network.all_logistic_robots == 10)
    assert(storage.requester.get_item_count("iron-plate") == 100, "passive provider -> requester failed")
    assert(storage.chest.get_item_count("copper-plate") == 100, "active provider -> storage failed")
    assert(storage.buffer.get_item_count("iron-gear-wheel") == 100, "buffer request failed")
    assert(storage.passive.get_inventory(defines.inventory.chest).is_empty()
      and storage.active.get_inventory(defines.inventory.chest).is_empty(), "providers did not drain")
    storage.requester.request_from_buffers = true
    request(storage.requester, "iron-gear-wheel", 100)
  elseif event.tick == 7200 then
    assert(storage.requester.get_item_count("iron-gear-wheel") == 100, "buffer -> requester failed")
    assert(storage.buffer.get_item_count("iron-gear-wheel") == 0)
    assert(storage.requester.get_item_count("iron-plate") == 100)
    assert(storage.chest.get_item_count("copper-plate") == 100)
    assert(storage.port.logistic_network.all_logistic_robots == 10, "robots were lost")
    log("FACTORIO LIGHT PLATFORM LOGISTICS PASSED")
  end
end)
