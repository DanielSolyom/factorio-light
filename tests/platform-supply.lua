-- Craft, ship and empty fluids using the engine's platform-to-platform logistics.
local function platform(name)
  local p = assert(game.forces.player.create_space_platform{
    name = name, planet = "nauvis", starter_pack = "space-platform-starter-pack"})
  p.apply_starter_pack()
  p.schedule = {current = 1, records = {{station = "nauvis", allows_unloading = true,
    wait_conditions = {{type = "time", compare_type = "and", ticks = 36000}}}}}
  p.paused = false
  local tiles = {}
  for x = 10, 30 do for y = -10, 10 do
    tiles[#tiles+1] = {name = "space-platform-foundation", position = {x,y}}
  end end
  p.surface.set_tiles(tiles)
  p.hub.request_missing_construction_materials = false
  p.hub.providing_to_other_platforms = true
  return p
end

local function request(section, slot, name, count)
  section.set_slot(slot, {value = {type = "item", name = name, quality = "normal", comparator = "="},
    min = count, max = count, minimum_delivery_count = 1,
    import_from = "nauvis", request_from = "platforms"})
end

script.on_init(function()
  game.forces.player.research_all_technologies()
  local source, target = platform("Fluid supply"), platform("Fluid receiver")
  storage.source, storage.target = source.hub, target.hub
  local incoming = target.hub.get_logistic_point(defines.logistic_member_index.space_platform_hub_requester).add_section()
  local returns = source.hub.get_logistic_point(defines.logistic_member_index.space_platform_hub_requester).add_section()
  request(returns, 1, "barrel", 3)
  storage.cases = {}
  for i, fluid in ipairs({"water", "thruster-fuel", "thruster-oxidizer"}) do
    local fill = assert(source.surface.create_entity{
      name = "assembling-machine-3", position = {14 + 5*i, 0}, force = "player"})
    local empty = assert(target.surface.create_entity{
      name = "assembling-machine-3", position = {14 + 5*i, 0}, force = "player"})
    local item = fluid .. "-barrel"
    fill.set_recipe(item)
    empty.set_recipe("empty-" .. item)
    assert(fill.get_recipe().name == item and empty.get_recipe().name == "empty-" .. item)
    fill.insert{name = "barrel", count = 1}
    assert(fill.insert_fluid{name = fluid, amount = 50} == 50)
    request(incoming, i, item, 1)
    storage.cases[i] = {fill = fill, empty = empty, fluid = fluid, item = item}
  end
end)

script.on_event(defines.events.on_tick, function(event)
  for _, case in ipairs(storage.cases) do
    case.fill.energy, case.empty.energy = 100000000, 100000000
    if not case.sent and case.fill.get_output_inventory().get_item_count(case.item) == 1 then
      assert(case.fill.get_output_inventory().remove{name = case.item, count = 1} == 1)
      assert(storage.source.insert{name = case.item, count = 1} == 1)
      case.sent = true
    end
    -- Moving items between machines and their own hub substitutes only for inserters.
    -- The game must transport all filled and empty barrels between platforms itself.
    if not case.received and storage.target.get_item_count(case.item) == 1 then
      assert(storage.target.remove_item{name = case.item, count = 1} == 1)
      assert(case.empty.insert{name = case.item, count = 1} == 1)
      case.received = true
    end
    if not case.returned and case.empty.get_output_inventory().get_item_count("barrel") == 1 then
      assert(case.empty.get_output_inventory().remove{name = "barrel", count = 1} == 1)
      assert(storage.target.insert{name = "barrel", count = 1} == 1)
      case.returned = true
    end
  end
  if event.tick ~= 7200 then return end
  for _, case in ipairs(storage.cases) do
    assert(case.sent and case.received and case.returned, "incomplete delivery: " .. case.fluid)
    assert(case.empty.get_fluid_count(case.fluid) == 50, "fluid conservation: " .. case.fluid)
    assert(storage.source.get_item_count(case.item) == 0 and storage.target.get_item_count(case.item) == 0)
  end
  assert(storage.source.get_item_count("barrel") == 3, "empty barrels must return via cargo pods")
  assert(storage.target.get_item_count("barrel") == 0)
  log("FACTORIO LIGHT PLATFORM SUPPLY PASSED")
end)
