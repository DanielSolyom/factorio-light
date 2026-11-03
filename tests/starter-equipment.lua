-- --test-scenario creates a real connected player and runs the real freeplay events.
require("__base__/script/freeplay/control.lua")
local handler = require("event_handler")
local repair = require("__factorio-light-space-age__/scripts/starter-equipment")

local function equipped(player)
  local character = assert(player.character or player.cutscene_character)
  local guns = character.get_inventory(defines.inventory.character_guns)
  local ammo = character.get_inventory(defines.inventory.character_ammo)
  local main = character.get_inventory(defines.inventory.character_main)
  assert(guns[1].valid_for_read and guns[1].name == "submachine-gun", "SMG must be equipped")
  assert(ammo[1].valid_for_read and ammo[1].name == "firearm-magazine" and ammo[1].count == 100,
    "100 yellow magazines must be loaded beside the SMG")
  assert(main.get_item_count("firearm-magazine") == 0, "starting ammo left in backpack")
  return character, guns, ammo, main
end

handler.add_lib({
  events = {
    [defines.events.on_player_respawned] = function() storage.respawn_seen = true end,
    [defines.events.on_tick] = function(event)
      local player = assert(game.get_player(1))
      if event.tick == 1 then
        local character = equipped(player)
        if player.controller_type == defines.controllers.cutscene then player.exit_cutscene() end
        character.destructible = true
        character.die()
        player.ticks_to_respawn = nil
      elseif event.tick == 2 then
        assert(storage.respawn_seen, "real respawn event must run")
        local character, guns, ammo, main = equipped(player)
        -- Recreate the reported inventory state alongside occupied ammo slots.
        assert(main.insert(ammo[1]) == 100)
        ammo[1].clear()
        guns[2].set_stack{name = "submachine-gun", count = 1}
        ammo[2].set_stack{name = "piercing-rounds-magazine", count = 20}
        guns[3].set_stack{name = "shotgun", count = 1}
        ammo[3].set_stack{name = "shotgun-shell", count = 20}
        main.insert{name = "iron-plate", count = 8}
        character.selected_gun_index = 2
        assert(repair(player))
        assert(repair(player), "repair must be safe to repeat")
        equipped(player)
        assert(guns[2].name == "submachine-gun" and ammo[2].name == "piercing-rounds-magazine" and ammo[2].count == 20,
          "existing SMG ammo must not be replaced")
        assert(guns[3].name == "shotgun" and ammo[3].name == "shotgun-shell" and ammo[3].count == 20)
        assert(main.get_item_count("iron-plate") == 8)
        assert(character.selected_gun_index == 2, "selected gun must not change")
        -- A player without a character must be deferred, never given extra items.
        assert(not repair({}))
      elseif event.tick == 10 then
        log("FACTORIO LIGHT STARTER EQUIPMENT PASSED")
        script.finish_test(true)
      end
    end
  }
})
