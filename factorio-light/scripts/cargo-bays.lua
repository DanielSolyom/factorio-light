-- Platform inventory access is native through proxy containers. Lua only
-- maintains their targets when construction changes the cargo-bay network.
local proxy_name = "factorio-light-cargo-bay-output"
local cargo = {}

local function state()
  storage.cargo_bays = storage.cargo_bays or {surfaces = {}, registrations = {}}
  return storage.cargo_bays
end

local function watch(entity)
  local registration = script.register_on_object_destroyed(entity)
  state().registrations[registration] = entity.surface.index
end

local function refresh(surface)
  if not (surface and surface.valid and surface.platform) then return end
  local s = state()
  local records = s.surfaces[surface.index] or {}
  s.surfaces[surface.index] = records
  local hub = surface.platform.hub
  if hub and hub.valid then watch(hub) end
  for _, bay in pairs(surface.find_entities_filtered{name = "cargo-bay"}) do
    local record = records[bay.unit_number]
    if not record then
      record = {bay = bay}
      records[bay.unit_number] = record
      watch(bay)
    end
    local owner = bay.cargo_bay_connection_owner
    if owner and owner.valid and owner.type == "space-platform-hub" and owner.force == bay.force then
      local proxy = record.proxy
      if not (proxy and proxy.valid) then
        proxy = assert(surface.create_entity{name = proxy_name, position = bay.position, force = bay.force})
        proxy.destructible = false
        record.proxy = proxy
      end
      proxy.proxy_target_entity = owner
      proxy.proxy_target_inventory = defines.inventory.hub_main
    elseif record.proxy and record.proxy.valid then
      record.proxy.destroy()
      record.proxy = nil
    end
  end
  for id, record in pairs(records) do
    if not record.bay.valid then
      if record.proxy and record.proxy.valid then record.proxy.destroy() end
      records[id] = nil
    end
  end
end

function cargo.rebuild()
  -- Also handles installing/updating the mod in a save with existing platforms.
  for _, surface in pairs(game.surfaces) do
    for _, proxy in pairs(surface.find_entities_filtered{name = proxy_name}) do proxy.destroy() end
  end
  state().surfaces = {}
  for _, surface in pairs(game.surfaces) do refresh(surface) end
end

function cargo.on_built(event)
  local entity = event.entity or event.destination
  if not (entity and entity.valid) then return end
  -- Area cloning can copy helpers after their parent has already been cloned.
  if entity.name == proxy_name then entity.destroy(); return end
  if entity.type == "cargo-bay" or entity.type == "space-platform-hub" then refresh(entity.surface) end
end

function cargo.on_removing(event)
  local entity = event.entity
  if not (entity and entity.valid and entity.surface.platform) then return end
  if entity.type ~= "cargo-bay" and entity.type ~= "space-platform-hub" then return end
  watch(entity)
  -- Mining/death notifications precede actual removal. Suspend access until
  -- on_object_destroyed can read the updated native connectivity graph.
  for _, record in pairs(state().surfaces[entity.surface.index] or {}) do
    if record.proxy and record.proxy.valid then record.proxy.proxy_target_entity = nil end
  end
end

function cargo.on_destroyed(event)
  local s = state()
  local index = s.registrations[event.registration_number]
  if not index then return end
  s.registrations[event.registration_number] = nil
  local surface = game.surfaces[index]
  if surface then refresh(surface) else s.surfaces[index] = nil end
end

return cargo
