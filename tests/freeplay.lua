-- Exercise the real freeplay interface and lifecycle, including save reload.
require("__base__/script/freeplay/control.lua")
local handler = require("event_handler")
handler.add_lib({events = {[defines.events.on_tick] = function(event)
  if event.tick ~= 1 then return end
  for _, kind in ipairs({"created", "respawn"}) do
    local items = remote.call("freeplay", "get_" .. kind .. "_items")
    assert(items.pistol == nil)
    assert(items["submachine-gun"] == 1)
    assert(items["firearm-magazine"] == 100)
  end
  assert(not remote.call("freeplay", "get_ship_items")["firearm-magazine"])
  assert(game.forces.player.recipes["submachine-gun"].enabled)
  log("FACTORIO LIGHT FREEPLAY PASSED")
end}})
