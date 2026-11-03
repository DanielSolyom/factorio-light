-- Transfer existing ammo only; never grant items or replace a loaded magazine.
return function(player)
  -- Freeplay starts its crash-site cutscene before mod player-created handlers.
  local character = player.character or player.cutscene_character
  if not character then return false end
  local guns = character.get_inventory(defines.inventory.character_guns)
  local ammo = character.get_inventory(defines.inventory.character_ammo)
  local main = character.get_inventory(defines.inventory.character_main)
  for index = 1, #guns do
    if guns[index].valid_for_read and guns[index].name == "submachine-gun"
      and not ammo[index].valid_for_read then
      local magazines = main.find_item_stack("firearm-magazine")
      if magazines then ammo[index].transfer_stack(magazines) end
    end
  end
  return true
end
