-- Native loaders default to output mode, regardless of neighbouring machines.
-- Placement snapping follows the approach used by Krastorio 2 (LGPL-3.0).
-- Item movement remains entirely in the engine; this only handles construction.
local offsets = {
  [defines.direction.north] = {0, -1},
  [defines.direction.east] = {1, 0},
  [defines.direction.south] = {0, 1},
  [defines.direction.west] = {-1, 0}
}
local names = {
  "factorio-light-loader", "factorio-light-fast-loader",
  "factorio-light-express-loader", "factorio-light-turbo-loader"
}
local supported = {}
for _, name in ipairs(names) do supported[name] = true end
local belt_types = {"transport-belt", "underground-belt", "splitter", "lane-splitter",
  "linked-belt", "loader", "loader-1x1"}

local function opposite(direction) return (direction + 8) % 16 end

local function belt_at(entity, direction)
  local offset = offsets[direction]
  local position = {entity.position.x + offset[1], entity.position.y + offset[2]}
  return entity.surface.find_entities_filtered{
    position = position, force = entity.force, type = belt_types
  }[1] or entity.surface.find_entities_filtered{
    position = position, force = entity.force, ghost_type = belt_types
  }[1]
end

local function flip_connection(entity)
  local direction = entity.direction
  -- Changing loader_type also reverses direction. Restore the intended flow.
  entity.loader_type = entity.loader_type == "input" and "output" or "input"
  entity.direction = direction
  entity.update_connections()
end

local function snap(entity, repair)
  if not (entity and entity.valid and supported[entity.name]) then return end
  entity.update_connections()
  -- An existing, connected loader is intentional and must survive upgrades.
  if repair and entity.loader_container then return end
  if not entity.loader_container then
    flip_connection(entity)
    if not entity.loader_container then
      flip_connection(entity)
      if repair then return end
      local container_side = entity.loader_type == "input" and entity.direction or opposite(entity.direction)
      if belt_at(entity, container_side) then flip_connection(entity) end
    end
  end
  if repair then return end
  local belt_side = entity.loader_type == "output" and entity.direction or opposite(entity.direction)
  local belt = belt_at(entity, belt_side)
  if belt and belt.direction == opposite(entity.direction) then
    -- Reverse flow while retaining the same machine connection.
    entity.loader_type = entity.loader_type == "input" and "output" or "input"
  elseif belt and belt.direction ~= entity.direction then
    local belt_type = belt.type == "entity-ghost" and belt.ghost_type or belt.type
    if belt_type == "transport-belt" or belt_type == "underground-belt" then
      -- A perpendicular belt accepts side-loading; it cannot feed the loader.
      entity.loader_type = "output"
    end
  end
end

return {
  on_built = function(event) snap(event.entity or event.destination, false) end,
  repair = function()
    for _, surface in pairs(game.surfaces) do
      for _, entity in pairs(surface.find_entities_filtered{name = names}) do snap(entity, true) end
    end
  end
}
