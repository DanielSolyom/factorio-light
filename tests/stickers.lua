-- Food buffs and status effects must match duration AND actual healing/movement.
script.on_init(function()
  local surface = game.surfaces[1]
  surface.request_to_generate_chunks({0,0}, 2)
  surface.force_generate_chunk_requests()
  storage.cases = {}
  local quality = script.active_mods.quality and "legendary" or "normal"
  for i, name in ipairs({"yumako-regen-sticker", "bioflux-speed-regen-sticker",
    "jellynut-speed-sticker", "slowdown-sticker", "fire-sticker"}) do
    local target = surface.create_entity{name = "character", position = {i*5,0}, force = "player"}
    target.character_health_bonus = 1000000
    target.health = 1000
    local food = name:match("^(yumako)%-") or name:match("^(bioflux)%-") or name:match("^(jellynut)%-")
    local sticker
    if food then
      target.force = "enemy"
      local shooter = surface.create_entity{name = "character", position = {i*5, -3}, force = "player"}
      shooter.get_inventory(defines.inventory.character_guns)[1].set_stack{name = "nqnp-test-gun-" .. food, quality = quality}
      shooter.get_inventory(defines.inventory.character_ammo)[1].set_stack{name = "nqnp-test-" .. food, quality = quality, count = 1}
      shooter.selected_gun_index = 1
      shooter.shooting_state = {state = defines.shooting.shooting_enemies, position = target.position}
    else
      sticker = surface.create_entity{name = name, position = target.position,
        target = target, force = "player", quality = name == "fire-sticker" and "normal" or quality}
    end
    storage.cases[name] = {target = target, sticker = sticker}
  end
end)
script.on_event(defines.events.on_tick, function(event)
  if event.tick ~= 120 then return end
  local result = {}
  for name, case in pairs(storage.cases) do
    local lifetime = 0
    for _, sticker in pairs(case.target.stickers or {}) do lifetime = math.max(lifetime, sticker.time_to_live) end
    assert(lifetime > 0, "No status effect: " .. name)
    result[name] = {health = case.target.health, speed = case.target.character_running_speed,
      lifetime = lifetime}
  end
  helpers.write_file("stickers.json", helpers.table_to_json(result))
end)
