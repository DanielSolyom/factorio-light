-- Freeplay owns starter inventories. Use its supported interface; no tick loop.
local function configure_freeplay()
  if not remote.interfaces.freeplay then return end
  -- Freeplay subtracts crash-site ammunition from the character's starting
  -- inventory. Keep the requested full stack on the character instead.
  if remote.interfaces.freeplay.get_ship_items and remote.interfaces.freeplay.set_ship_items then
    local ship = remote.call("freeplay", "get_ship_items")
    ship["firearm-magazine"] = nil
    remote.call("freeplay", "set_ship_items", ship)
  end
  for _, kind in ipairs({"created", "respawn"}) do
    local get, set = "get_" .. kind .. "_items", "set_" .. kind .. "_items"
    if remote.interfaces.freeplay[get] and remote.interfaces.freeplay[set] then
      local items = remote.call("freeplay", get)
      items.pistol = nil
      items["submachine-gun"] = 1
      items["firearm-magazine"] = prototypes.item["firearm-magazine"].stack_size
      remote.call("freeplay", set, items)
    end
  end
end

local load_starter_ammo = require("scripts.starter-equipment")
local loader_placement = require("scripts.loader-placement")
local function equip_starter_ammo(player)
  if not remote.interfaces.freeplay then return end
  storage.pending_starter_ammo = storage.pending_starter_ammo or {}
  storage.pending_starter_ammo[player.index] = not load_starter_ammo(player) or nil
end

script.on_init(configure_freeplay)
script.on_configuration_changed(function(event)
  configure_freeplay()
  if event.mod_changes["factorio-light-space-age"] then loader_placement.repair() end
  for _, force in pairs(game.forces) do
    force.recipes["submachine-gun"].enabled = true
  end
  -- Repair older saves without granting items or replacing equipped ammunition.
  for _, player in pairs(game.players) do equip_starter_ammo(player) end
end)

script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity,
  defines.events.on_space_platform_built_entity, defines.events.script_raised_built,
  defines.events.script_raised_revive, defines.events.on_entity_cloned}, loader_placement.on_built)

script.on_event({defines.events.on_player_created, defines.events.on_player_respawned}, function(event)
  equip_starter_ammo(game.get_player(event.player_index))
end)

script.on_event(defines.events.on_player_joined_game, function(event)
  if storage.pending_starter_ammo and storage.pending_starter_ammo[event.player_index] then
    equip_starter_ammo(game.get_player(event.player_index))
  end
end)
