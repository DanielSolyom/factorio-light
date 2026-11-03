-- Adapted from Daniel Solyom’s No Quality, No Problem (MIT); see THIRD_PARTY.md.
-- Headless servers have no connected LuaPlayer to call use_from_cursor. Expose
-- each capsule's original attack through a gun/ammo pair for the combat oracle.
for _, name in ipairs{"defender-capsule", "distractor-capsule", "destroyer-capsule", "grenade", "cluster-grenade", "poison-capsule", "slowdown-capsule", "yumako", "bioflux", "jellynut"} do
  local capsule = data.raw.capsule[name]
  local attack = capsule.capsule_action.attack_parameters
  if attack then
    local gun = table.deepcopy(data.raw.gun["submachine-gun"])
    gun.name = "nqnp-test-gun-" .. name
    gun.attack_parameters = table.deepcopy(attack)
    gun.attack_parameters.ammo_type = nil
    gun.attack_parameters.ammo_category = "bullet"
    gun.attack_parameters.activation_type = "shoot"
    gun.attack_parameters.range = math.max(20, gun.attack_parameters.range)
    local ammo = table.deepcopy(data.raw.ammo["firearm-magazine"])
    ammo.name = "nqnp-test-" .. name
    ammo.magazine_size = 1
    ammo.ammo_type = table.deepcopy(attack.ammo_type)
    if capsule.capsule_action.type == "use-on-self" then ammo.ammo_type.target_type = "entity" end
    data:extend{gun, ammo}
  end
end

-- Exercise actual vanilla ammo deliveries with one synthetic shot per case.
for _, name in ipairs{"firearm-magazine", "piercing-rounds-magazine", "uranium-rounds-magazine", "shotgun-shell", "piercing-shotgun-shell", "cannon-shell", "explosive-cannon-shell", "uranium-cannon-shell", "explosive-uranium-cannon-shell", "rocket", "explosive-rocket", "flamethrower-ammo", "tesla-ammo", "railgun-ammo", "artillery-shell"} do
  local gun = table.deepcopy(data.raw.gun["submachine-gun"])
  gun.name = "nqnp-test-gun-" .. name
  gun.attack_parameters.range = 40
  local ammo = table.deepcopy(data.raw.ammo[name])
  ammo.name = "nqnp-test-" .. name
  ammo.ammo_category = "bullet"
  ammo.magazine_size = 1
  data:extend{gun, ammo}
end
