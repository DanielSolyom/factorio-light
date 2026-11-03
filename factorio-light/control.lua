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

script.on_init(configure_freeplay)
script.on_configuration_changed(function()
  configure_freeplay()
  for _, force in pairs(game.forces) do
    force.recipes["submachine-gun"].enabled = true
  end
end)
