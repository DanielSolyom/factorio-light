-- Fixed vanilla legendary values, reviewed against Factorio 2.1.24.
-- Generated offline by scripts/generate_fixed_stats.py; NO quality changes,
-- discovery, scaling loops or third-party prototype changes at game load.

local player_fire = table.deepcopy(data.raw.fire["fire-flame"])
player_fire.name = "factorio-light-fire-flame"
local player_sticker = table.deepcopy(data.raw.sticker["fire-sticker"])
player_sticker.name = "factorio-light-fire-sticker"
data:extend({player_fire, player_sticker})

-- accumulator
data.raw["accumulator"]["accumulator"].energy_source.buffer_capacity = "30MJ"
data.raw["accumulator"]["accumulator"].energy_source.input_flow_limit = "750kW"
data.raw["accumulator"]["accumulator"].energy_source.output_flow_limit = "750kW"
data.raw["accumulator"]["accumulator"].max_health = 375

-- discharge-defense-equipment
data.raw["active-defense-equipment"]["discharge-defense-equipment"].attack_parameters.damage_modifier = 25
data.raw["active-defense-equipment"]["discharge-defense-equipment"].attack_parameters.range = 15

-- personal-laser-defense-equipment
data.raw["active-defense-equipment"]["personal-laser-defense-equipment"].attack_parameters.damage_modifier = 2.5
data.raw["active-defense-equipment"]["personal-laser-defense-equipment"].attack_parameters.range = 22.5

-- agricultural-tower
data.raw["agricultural-tower"]["agricultural-tower"].max_health = 1250

-- firearm-magazine
data.raw["ammo"]["firearm-magazine"].ammo_type.action[1].action_delivery[1].target_effects[3].damage.amount = 12.5

-- piercing-rounds-magazine
data.raw["ammo"]["piercing-rounds-magazine"].ammo_type.action.action_delivery.target_effects[3].damage.amount = 20

-- railgun-ammo
data.raw["ammo"]["railgun-ammo"].ammo_type.action.action_delivery.target_effects.damage.amount = 25000

-- uranium-rounds-magazine
data.raw["ammo"]["uranium-rounds-magazine"].ammo_type.action.action_delivery.target_effects[3].damage.amount = 60

-- gun-turret
data.raw["ammo-turret"]["gun-turret"].attack_parameters.range = 27
data.raw["ammo-turret"]["gun-turret"].max_health = 1000

-- railgun-turret
data.raw["ammo-turret"]["railgun-turret"].attack_parameters.range = 60
data.raw["ammo-turret"]["railgun-turret"].energy_source.input_flow_limit = "25MW"
data.raw["ammo-turret"]["railgun-turret"].max_health = 10000

-- rocket-turret
data.raw["ammo-turret"]["rocket-turret"].attack_parameters.range = 54
data.raw["ammo-turret"]["rocket-turret"].max_health = 3750

-- arithmetic-combinator
data.raw["arithmetic-combinator"]["arithmetic-combinator"].max_health = 375

-- heavy-armor
data.raw["armor"]["heavy-armor"].inventory_size_bonus = 0

-- light-armor
data.raw["armor"]["light-armor"].inventory_size_bonus = 0

-- mech-armor
data.raw["armor"]["mech-armor"].inventory_size_bonus = 125

-- modular-armor
data.raw["armor"]["modular-armor"].inventory_size_bonus = 25

-- power-armor
data.raw["armor"]["power-armor"].inventory_size_bonus = 50

-- power-armor-mk2
data.raw["armor"]["power-armor-mk2"].inventory_size_bonus = 75

-- artillery-projectile
data.raw["artillery-projectile"]["artillery-projectile"].action.action_delivery.target_effects[1].action.action_delivery.target_effects[1].damage.amount = 2500
data.raw["artillery-projectile"]["artillery-projectile"].action.action_delivery.target_effects[1].action.action_delivery.target_effects[2].damage.amount = 2500

-- artillery-turret
data.raw["artillery-turret"]["artillery-turret"].max_health = 5000

-- artillery-wagon
data.raw["artillery-wagon"]["artillery-wagon"].max_health = 1500

-- assembling-machine-1
data.raw["assembling-machine"]["assembling-machine-1"].crafting_speed = 1.25
data.raw["assembling-machine"]["assembling-machine-1"].max_health = 750

-- assembling-machine-2
data.raw["assembling-machine"]["assembling-machine-2"].crafting_speed = 1.875
data.raw["assembling-machine"]["assembling-machine-2"].max_health = 875

-- assembling-machine-3
data.raw["assembling-machine"]["assembling-machine-3"].crafting_speed = 3.125
data.raw["assembling-machine"]["assembling-machine-3"].max_health = 1000

-- biochamber
data.raw["assembling-machine"]["biochamber"].crafting_speed = 5
data.raw["assembling-machine"]["biochamber"].max_health = 750

-- captive-biter-spawner
data.raw["assembling-machine"]["captive-biter-spawner"].crafting_speed = 2.5
data.raw["assembling-machine"]["captive-biter-spawner"].max_health = 875

-- centrifuge
data.raw["assembling-machine"]["centrifuge"].crafting_speed = 2.5
data.raw["assembling-machine"]["centrifuge"].max_health = 875

-- chemical-plant
data.raw["assembling-machine"]["chemical-plant"].crafting_speed = 2.5
data.raw["assembling-machine"]["chemical-plant"].max_health = 750

-- crusher
data.raw["assembling-machine"]["crusher"].crafting_speed = 2.5
data.raw["assembling-machine"]["crusher"].max_health = 875

-- cryogenic-plant
data.raw["assembling-machine"]["cryogenic-plant"].crafting_speed = 5
data.raw["assembling-machine"]["cryogenic-plant"].max_health = 875

-- electromagnetic-plant
data.raw["assembling-machine"]["electromagnetic-plant"].crafting_speed = 5
data.raw["assembling-machine"]["electromagnetic-plant"].max_health = 875

-- foundry
data.raw["assembling-machine"]["foundry"].crafting_speed = 10
data.raw["assembling-machine"]["foundry"].max_health = 875

-- oil-refinery
data.raw["assembling-machine"]["oil-refinery"].crafting_speed = 2.5
data.raw["assembling-machine"]["oil-refinery"].max_health = 875

-- asteroid-collector
data.raw["asteroid-collector"]["asteroid-collector"].arm_angular_speed_cap_base = 0.25
data.raw["asteroid-collector"]["asteroid-collector"].arm_count_base = 6
data.raw["asteroid-collector"]["asteroid-collector"].arm_energy_usage = "1.5kJ"
data.raw["asteroid-collector"]["asteroid-collector"].arm_slow_energy_usage = "450J"
data.raw["asteroid-collector"]["asteroid-collector"].arm_speed_base = 0.25
data.raw["asteroid-collector"]["asteroid-collector"].collection_radius = 12.5
data.raw["asteroid-collector"]["asteroid-collector"].inventory_size = 64
data.raw["asteroid-collector"]["asteroid-collector"].max_health = 750
data.raw["asteroid-collector"]["asteroid-collector"].passive_energy_usage = "300J"

-- battery-equipment
data.raw["battery-equipment"]["battery-equipment"].energy_source.buffer_capacity = "50MJ"

-- battery-mk2-equipment
data.raw["battery-equipment"]["battery-mk2-equipment"].energy_source.buffer_capacity = "250MJ"

-- battery-mk3-equipment
data.raw["battery-equipment"]["battery-mk3-equipment"].energy_source.buffer_capacity = "625MJ"

-- beacon
data.raw["beacon"]["beacon"].distribution_effectivity = 2.5
data.raw["beacon"]["beacon"].energy_usage = "80kW"
data.raw["beacon"]["beacon"].max_health = 500

-- chain-tesla-gun-beam-bounce
data.raw["beam"]["chain-tesla-gun-beam-bounce"].action.action_delivery.target_effects[1].damage.amount = 75

-- chain-tesla-gun-beam-start
data.raw["beam"]["chain-tesla-gun-beam-start"].action.action_delivery.target_effects[1].damage.amount = 75

-- belt-immunity-equipment
data.raw["belt-immunity-equipment"]["belt-immunity-equipment"].energy_consumption = "40kW"

-- boiler
data.raw["boiler"]["boiler"].energy_consumption = "4.5MW"
data.raw["boiler"]["boiler"].max_health = 500

-- heat-exchanger
data.raw["boiler"]["heat-exchanger"].energy_consumption = "25MW"
data.raw["boiler"]["heat-exchanger"].max_health = 500

-- burner-generator
data.raw["burner-generator"]["burner-generator"].max_health = 1000

-- bioflux
data.raw["capsule"]["bioflux"].capsule_action.attack_parameters.ammo_type.action.action_delivery.target_effects[1].damage.amount = -200

-- cliff-explosives
data.raw["capsule"]["cliff-explosives"].capsule_action.attack_parameters.range = 15

-- cluster-grenade
data.raw["capsule"]["cluster-grenade"].capsule_action.attack_parameters.range = 30

-- defender-capsule
data.raw["capsule"]["defender-capsule"].capsule_action.attack_parameters.range = 30

-- destroyer-capsule
data.raw["capsule"]["destroyer-capsule"].capsule_action.attack_parameters.range = 37.5

-- distractor-capsule
data.raw["capsule"]["distractor-capsule"].capsule_action.attack_parameters.range = 37.5

-- grenade
data.raw["capsule"]["grenade"].capsule_action.attack_parameters.range = 22.5

-- poison-capsule
data.raw["capsule"]["poison-capsule"].capsule_action.attack_parameters.range = 37.5

-- raw-fish
data.raw["capsule"]["raw-fish"].capsule_action.attack_parameters.ammo_type.action.action_delivery.target_effects[1].damage.amount = -200

-- slowdown-capsule
data.raw["capsule"]["slowdown-capsule"].capsule_action.attack_parameters.range = 37.5

-- yumako
data.raw["capsule"]["yumako"].capsule_action.attack_parameters.ammo_type.action.action_delivery.target_effects[1].damage.amount = -200

-- yumako-mash
data.raw["capsule"]["yumako-mash"].capsule_action.attack_parameters.ammo_type.action.action_delivery.target_effects[1].damage.amount = -200

-- car
data.raw["car"]["car"].max_health = 1125

-- tank
data.raw["car"]["tank"].max_health = 5000

-- cargo-bay
data.raw["cargo-bay"]["cargo-bay"].inventory_size_bonus = 50
data.raw["cargo-bay"]["cargo-bay"].max_health = 2500

-- landing-pad-unloading-bay
data.raw["cargo-bay"]["landing-pad-unloading-bay"].inventory_size_bonus = 50
data.raw["cargo-bay"]["landing-pad-unloading-bay"].max_health = 2500

-- cargo-landing-pad
data.raw["cargo-landing-pad"]["cargo-landing-pad"].max_health = 2500
data.raw["cargo-landing-pad"]["cargo-landing-pad"].radar_range = 9

-- cargo-wagon
data.raw["cargo-wagon"]["cargo-wagon"].inventory_size = 100
data.raw["cargo-wagon"]["cargo-wagon"].max_health = 1500

-- chain-tesla-gun-chain
data.raw["chain-active-trigger"]["chain-tesla-gun-chain"].fork_chance = 0.55

-- chain-tesla-turret-chain
data.raw["chain-active-trigger"]["chain-tesla-turret-chain"].fork_chance = 0.3

-- character
data.raw["character"]["character"].max_health = 625

-- defender
data.raw["combat-robot"]["defender"].attack_parameters.damage_modifier = 2.5
data.raw["combat-robot"]["defender"].attack_parameters.range = 22.5
data.raw["combat-robot"]["defender"].max_health = 150
data.raw["combat-robot"]["defender"].time_to_live = 6750

-- destroyer
data.raw["combat-robot"]["destroyer"].attack_parameters.damage_modifier = 5
data.raw["combat-robot"]["destroyer"].attack_parameters.range = 30
data.raw["combat-robot"]["destroyer"].max_health = 150
data.raw["combat-robot"]["destroyer"].time_to_live = 18000

-- distractor
data.raw["combat-robot"]["distractor"].attack_parameters.damage_modifier = 1.25
data.raw["combat-robot"]["distractor"].attack_parameters.range = 22.5
data.raw["combat-robot"]["distractor"].max_health = 450
data.raw["combat-robot"]["distractor"].time_to_live = 13500

-- constant-combinator
data.raw["constant-combinator"]["constant-combinator"].max_health = 300

-- construction-robot
data.raw["construction-robot"]["construction-robot"].max_energy = "18MJ"
data.raw["construction-robot"]["construction-robot"].max_health = 250

-- bottomless-chest
data.raw["container"]["bottomless-chest"].inventory_size = 2.5
data.raw["container"]["bottomless-chest"].max_health = 10000

-- iron-chest
data.raw["container"]["iron-chest"].inventory_size = 80
data.raw["container"]["iron-chest"].max_health = 500

-- steel-chest
data.raw["container"]["steel-chest"].inventory_size = 120
data.raw["container"]["steel-chest"].max_health = 875

-- wooden-chest
data.raw["container"]["wooden-chest"].inventory_size = 40
data.raw["container"]["wooden-chest"].max_health = 250

-- curved-rail-a
data.raw["curved-rail-a"]["curved-rail-a"].max_health = 500

-- curved-rail-b
data.raw["curved-rail-b"]["curved-rail-b"].max_health = 500

-- decider-combinator
data.raw["decider-combinator"]["decider-combinator"].max_health = 375

-- display-panel
data.raw["display-panel"]["display-panel"].max_health = 125

-- electric-energy-interface
data.raw["electric-energy-interface"]["electric-energy-interface"].max_health = 375

-- big-electric-pole
data.raw["electric-pole"]["big-electric-pole"].max_health = 375
data.raw["electric-pole"]["big-electric-pole"].maximum_wire_distance = 42
data.raw["electric-pole"]["big-electric-pole"].supply_area_distance = 7

-- medium-electric-pole
data.raw["electric-pole"]["medium-electric-pole"].max_health = 250
data.raw["electric-pole"]["medium-electric-pole"].maximum_wire_distance = 19
data.raw["electric-pole"]["medium-electric-pole"].supply_area_distance = 8.5

-- small-electric-pole
data.raw["electric-pole"]["small-electric-pole"].max_health = 250
data.raw["electric-pole"]["small-electric-pole"].maximum_wire_distance = 17.5
data.raw["electric-pole"]["small-electric-pole"].supply_area_distance = 7.5

-- substation
data.raw["electric-pole"]["substation"].max_health = 500
data.raw["electric-pole"]["substation"].maximum_wire_distance = 28
data.raw["electric-pole"]["substation"].supply_area_distance = 14

-- laser-turret
data.raw["electric-turret"]["laser-turret"].attack_parameters.range = 36
data.raw["electric-turret"]["laser-turret"].max_health = 2500

-- tesla-turret
data.raw["electric-turret"]["tesla-turret"].attack_parameters.range = 45
data.raw["electric-turret"]["tesla-turret"].max_health = 5000

-- elevated-curved-rail-a
data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a"].max_health = 500

-- elevated-curved-rail-b
data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b"].max_health = 500

-- elevated-half-diagonal-rail
data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail"].max_health = 500

-- elevated-straight-rail
data.raw["elevated-straight-rail"]["elevated-straight-rail"].max_health = 500

-- energy-shield-equipment
data.raw["energy-shield-equipment"]["energy-shield-equipment"].energy_source.input_flow_limit = "600kW"
data.raw["energy-shield-equipment"]["energy-shield-equipment"].max_shield_value = 125

-- energy-shield-mk2-equipment
data.raw["energy-shield-equipment"]["energy-shield-mk2-equipment"].energy_source.input_flow_limit = "900kW"
data.raw["energy-shield-equipment"]["energy-shield-mk2-equipment"].max_shield_value = 375

-- huge-equipment-grid
data.raw["equipment-grid"]["huge-equipment-grid"].height = 17
data.raw["equipment-grid"]["huge-equipment-grid"].width = 15

-- large-equipment-grid
data.raw["equipment-grid"]["large-equipment-grid"].height = 15
data.raw["equipment-grid"]["large-equipment-grid"].width = 15

-- medium-equipment-grid
data.raw["equipment-grid"]["medium-equipment-grid"].height = 13
data.raw["equipment-grid"]["medium-equipment-grid"].width = 11

-- small-equipment-grid
data.raw["equipment-grid"]["small-equipment-grid"].height = 10
data.raw["equipment-grid"]["small-equipment-grid"].width = 10

-- spidertron-equipment-grid
data.raw["equipment-grid"]["spidertron-equipment-grid"].height = 11
data.raw["equipment-grid"]["spidertron-equipment-grid"].width = 15

-- nuke-effects-space
data.raw["explosion"]["nuke-effects-space"].created_effect.action_delivery.target_effects[1].damage.amount = 2500
data.raw["explosion"]["nuke-effects-space"].created_effect.action_delivery.target_effects[2].damage.amount = 125

-- factorio-light-fire-flame
data.raw["fire"]["factorio-light-fire-flame"].damage_per_tick.amount = 0.541666666666667

-- flamethrower-turret
data.raw["fluid-turret"]["flamethrower-turret"].attack_parameters.range = 45
data.raw["fluid-turret"]["flamethrower-turret"].max_health = 3500

-- fluid-wagon
data.raw["fluid-wagon"]["fluid-wagon"].capacity = 125000
data.raw["fluid-wagon"]["fluid-wagon"].max_health = 1500

-- electric-furnace
data.raw["furnace"]["electric-furnace"].crafting_speed = 5
data.raw["furnace"]["electric-furnace"].max_health = 875

-- recycler
data.raw["furnace"]["recycler"].crafting_speed = 1.25
data.raw["furnace"]["recycler"].max_health = 750

-- steel-furnace
data.raw["furnace"]["steel-furnace"].crafting_speed = 5
data.raw["furnace"]["steel-furnace"].max_health = 750

-- stone-furnace
data.raw["furnace"]["stone-furnace"].crafting_speed = 2.5
data.raw["furnace"]["stone-furnace"].max_health = 500

-- fusion-generator
data.raw["fusion-generator"]["fusion-generator"].energy_source.output_flow_limit = "125MW"
data.raw["fusion-generator"]["fusion-generator"].max_fluid_usage = 0.0833333333333333
data.raw["fusion-generator"]["fusion-generator"].max_health = 2500

-- fusion-reactor
data.raw["fusion-reactor"]["fusion-reactor"].max_fluid_usage = 0.166666666666667
data.raw["fusion-reactor"]["fusion-reactor"].max_health = 2500

-- gate
data.raw["gate"]["gate"].max_health = 875

-- steam-engine
data.raw["generator"]["steam-engine"].fluid_usage_per_tick = 1.25
data.raw["generator"]["steam-engine"].max_health = 1000

-- steam-turbine
data.raw["generator"]["steam-turbine"].fluid_usage_per_tick = 2.5
data.raw["generator"]["steam-turbine"].max_health = 750

-- fission-reactor-equipment
data.raw["generator-equipment"]["fission-reactor-equipment"].power = "1875kW"

-- fusion-reactor-equipment
data.raw["generator-equipment"]["fusion-reactor-equipment"].power = "6250kW"

-- artillery-wagon-cannon
data.raw["gun"]["artillery-wagon-cannon"].attack_parameters.range = 336

-- combat-shotgun
data.raw["gun"]["combat-shotgun"].attack_parameters.range = 22.5

-- flamethrower
data.raw["gun"]["flamethrower"].attack_parameters.range = 22.5

-- railgun
data.raw["gun"]["railgun"].attack_parameters.range = 60

-- rocket-launcher
data.raw["gun"]["rocket-launcher"].attack_parameters.range = 54

-- shotgun
data.raw["gun"]["shotgun"].attack_parameters.range = 22.5

-- spidertron-rocket-launcher-1
data.raw["gun"]["spidertron-rocket-launcher-1"].attack_parameters.range = 54

-- spidertron-rocket-launcher-2
data.raw["gun"]["spidertron-rocket-launcher-2"].attack_parameters.range = 54

-- spidertron-rocket-launcher-3
data.raw["gun"]["spidertron-rocket-launcher-3"].attack_parameters.range = 54

-- spidertron-rocket-launcher-4
data.raw["gun"]["spidertron-rocket-launcher-4"].attack_parameters.range = 54

-- submachine-gun
data.raw["gun"]["submachine-gun"].attack_parameters.range = 27

-- tank-cannon
data.raw["gun"]["tank-cannon"].attack_parameters.range = 45

-- tank-flamethrower
data.raw["gun"]["tank-flamethrower"].attack_parameters.range = 13.5

-- tank-machine-gun
data.raw["gun"]["tank-machine-gun"].attack_parameters.range = 30

-- teslagun
data.raw["gun"]["teslagun"].attack_parameters.range = 36

-- vehicle-machine-gun
data.raw["gun"]["vehicle-machine-gun"].attack_parameters.range = 30

-- half-diagonal-rail
data.raw["half-diagonal-rail"]["half-diagonal-rail"].max_health = 500

-- heat-interface
data.raw["heat-interface"]["heat-interface"].max_health = 375

-- heat-pipe
data.raw["heat-pipe"]["heat-pipe"].max_health = 500

-- infinity-cargo-wagon
data.raw["infinity-cargo-wagon"]["infinity-cargo-wagon"].max_health = 1500

-- infinity-chest
data.raw["infinity-container"]["infinity-chest"].max_health = 875

-- infinity-pipe
data.raw["infinity-pipe"]["infinity-pipe"].max_health = 250

-- bulk-inserter
data.raw["inserter"]["bulk-inserter"].extension_speed = 0.25
data.raw["inserter"]["bulk-inserter"].max_health = 400
data.raw["inserter"]["bulk-inserter"].rotation_speed = 0.1

-- burner-inserter
data.raw["inserter"]["burner-inserter"].extension_speed = 0.0875
data.raw["inserter"]["burner-inserter"].max_health = 250
data.raw["inserter"]["burner-inserter"].rotation_speed = 0.0325

-- fast-inserter
data.raw["inserter"]["fast-inserter"].extension_speed = 0.25
data.raw["inserter"]["fast-inserter"].max_health = 375
data.raw["inserter"]["fast-inserter"].rotation_speed = 0.1

-- inserter
data.raw["inserter"]["inserter"].extension_speed = 0.0875
data.raw["inserter"]["inserter"].max_health = 375
data.raw["inserter"]["inserter"].rotation_speed = 0.035

-- long-handed-inserter
data.raw["inserter"]["long-handed-inserter"].extension_speed = 0.125
data.raw["inserter"]["long-handed-inserter"].max_health = 400
data.raw["inserter"]["long-handed-inserter"].rotation_speed = 0.05

-- stack-inserter
data.raw["inserter"]["stack-inserter"].extension_speed = 0.25
data.raw["inserter"]["stack-inserter"].max_health = 400
data.raw["inserter"]["stack-inserter"].rotation_speed = 0.1

-- toolbelt-equipment
data.raw["inventory-bonus-equipment"]["toolbelt-equipment"].inventory_size_bonus = 25

-- agricultural-science-pack
data.raw["item"]["agricultural-science-pack"].science_capacity = 6

-- automation-science-pack
data.raw["item"]["automation-science-pack"].science_capacity = 6

-- chemical-science-pack
data.raw["item"]["chemical-science-pack"].science_capacity = 6

-- coin
data.raw["item"]["coin"].science_capacity = 6

-- cryogenic-science-pack
data.raw["item"]["cryogenic-science-pack"].science_capacity = 6

-- electromagnetic-science-pack
data.raw["item"]["electromagnetic-science-pack"].science_capacity = 6

-- logistic-science-pack
data.raw["item"]["logistic-science-pack"].science_capacity = 6

-- metallurgic-science-pack
data.raw["item"]["metallurgic-science-pack"].science_capacity = 6

-- military-science-pack
data.raw["item"]["military-science-pack"].science_capacity = 6

-- nuclear-fuel
data.raw["item"]["nuclear-fuel"].fuel_acceleration_multiplier = 4.75
data.raw["item"]["nuclear-fuel"].fuel_top_speed_multiplier = 1.375

-- production-science-pack
data.raw["item"]["production-science-pack"].science_capacity = 6

-- promethium-science-pack
data.raw["item"]["promethium-science-pack"].science_capacity = 6

-- rocket-fuel
data.raw["item"]["rocket-fuel"].fuel_acceleration_multiplier = 3
data.raw["item"]["rocket-fuel"].fuel_top_speed_multiplier = 1.375

-- science
data.raw["item"]["science"].science_capacity = 6

-- solid-fuel
data.raw["item"]["solid-fuel"].fuel_acceleration_multiplier = 1.5
data.raw["item"]["solid-fuel"].fuel_top_speed_multiplier = 1.125

-- space-science-pack
data.raw["item"]["space-science-pack"].science_capacity = 6

-- utility-science-pack
data.raw["item"]["utility-science-pack"].science_capacity = 6

-- biolab
data.raw["lab"]["biolab"].max_health = 875
data.raw["lab"]["biolab"].researching_speed = 5

-- lab
data.raw["lab"]["lab"].max_health = 375
data.raw["lab"]["lab"].researching_speed = 2.5

-- small-lamp
data.raw["lamp"]["small-lamp"].max_health = 250

-- land-mine
data.raw["land-mine"]["land-mine"].max_health = 37.5

-- lane-splitter
data.raw["lane-splitter"]["lane-splitter"].max_health = 425

-- lightning-collector
data.raw["lightning-attractor"]["lightning-collector"].efficiency = 1
data.raw["lightning-attractor"]["lightning-collector"].max_health = 500
data.raw["lightning-attractor"]["lightning-collector"].range_elongation = 62.5

-- lightning-rod
data.raw["lightning-attractor"]["lightning-rod"].efficiency = 0.5
data.raw["lightning-attractor"]["lightning-rod"].max_health = 250
data.raw["lightning-attractor"]["lightning-rod"].range_elongation = 37.5

-- linked-belt
data.raw["linked-belt"]["linked-belt"].max_health = 400

-- linked-chest
data.raw["linked-container"]["linked-chest"].max_health = 250

-- express-loader
data.raw["loader"]["express-loader"].max_health = 425

-- fast-loader
data.raw["loader"]["fast-loader"].max_health = 425

-- loader
data.raw["loader"]["loader"].max_health = 425

-- turbo-loader
data.raw["loader"]["turbo-loader"].max_health = 425

-- locomotive
data.raw["locomotive"]["locomotive"].max_health = 2500
data.raw["locomotive"]["locomotive"].max_power = "1200kW"
data.raw["locomotive"]["locomotive"].max_speed = 1.38

-- active-provider-chest
data.raw["logistic-container"]["active-provider-chest"].inventory_size = 120
data.raw["logistic-container"]["active-provider-chest"].max_health = 875

-- buffer-chest
data.raw["logistic-container"]["buffer-chest"].inventory_size = 120
data.raw["logistic-container"]["buffer-chest"].max_health = 875

-- passive-provider-chest
data.raw["logistic-container"]["passive-provider-chest"].inventory_size = 120
data.raw["logistic-container"]["passive-provider-chest"].max_health = 875

-- requester-chest
data.raw["logistic-container"]["requester-chest"].inventory_size = 120
data.raw["logistic-container"]["requester-chest"].max_health = 875

-- storage-chest
data.raw["logistic-container"]["storage-chest"].inventory_size = 120
data.raw["logistic-container"]["storage-chest"].max_health = 875

-- logistic-robot
data.raw["logistic-robot"]["logistic-robot"].max_energy = "9MJ"
data.raw["logistic-robot"]["logistic-robot"].max_health = 250

-- big-mining-drill
data.raw["mining-drill"]["big-mining-drill"].max_health = 750
data.raw["mining-drill"]["big-mining-drill"].resource_drain_rate_percent = 8.33333333333333

-- burner-mining-drill
data.raw["mining-drill"]["burner-mining-drill"].max_health = 375
data.raw["mining-drill"]["burner-mining-drill"].resource_drain_rate_percent = 16.6666666666667

-- electric-mining-drill
data.raw["mining-drill"]["electric-mining-drill"].max_health = 750
data.raw["mining-drill"]["electric-mining-drill"].resource_drain_rate_percent = 16.6666666666667

-- pumpjack
data.raw["mining-drill"]["pumpjack"].max_health = 500
data.raw["mining-drill"]["pumpjack"].resource_drain_rate_percent = 16.6666666666667

-- efficiency-module
data.raw["module"]["efficiency-module"].effect.consumption = -0.75

-- efficiency-module-2
data.raw["module"]["efficiency-module-2"].effect.consumption = -1

-- efficiency-module-3
data.raw["module"]["efficiency-module-3"].effect.consumption = -1.25

-- productivity-module
data.raw["module"]["productivity-module"].effect.productivity = 0.1

-- productivity-module-2
data.raw["module"]["productivity-module-2"].effect.productivity = 0.15

-- productivity-module-3
data.raw["module"]["productivity-module-3"].effect.productivity = 0.25

-- speed-module
data.raw["module"]["speed-module"].effect.speed = 0.5

-- speed-module-2
data.raw["module"]["speed-module-2"].effect.speed = 0.75

-- speed-module-3
data.raw["module"]["speed-module-3"].effect.speed = 1.25

-- exoskeleton-equipment
data.raw["movement-bonus-equipment"]["exoskeleton-equipment"].movement_bonus = 0.75

-- offshore-pump
data.raw["offshore-pump"]["offshore-pump"].max_health = 375
data.raw["offshore-pump"]["offshore-pump"].pumping_speed = 50

-- pipe
data.raw["pipe"]["pipe"].max_health = 250

-- pipe-to-ground
data.raw["pipe-to-ground"]["pipe-to-ground"].max_health = 375

-- power-switch
data.raw["power-switch"]["power-switch"].max_health = 500

-- programmable-speaker
data.raw["programmable-speaker"]["programmable-speaker"].max_health = 375

-- atomic-bomb-ground-zero-projectile
data.raw["projectile"]["atomic-bomb-ground-zero-projectile"].action[1].action_delivery.target_effects.damage.amount = 250

-- atomic-bomb-wave
data.raw["projectile"]["atomic-bomb-wave"].action[1].action_delivery.target_effects.damage.amount = 1000

-- atomic-rocket
data.raw["projectile"]["atomic-rocket"].action.action_delivery.target_effects[10].damage.amount = 1000

-- cannon-projectile
data.raw["projectile"]["cannon-projectile"].action.action_delivery.target_effects[1].damage.amount = 2500
data.raw["projectile"]["cannon-projectile"].action.action_delivery.target_effects[2].damage.amount = 250

-- explosive-cannon-projectile
data.raw["projectile"]["explosive-cannon-projectile"].action.action_delivery.target_effects[1].damage.amount = 450
data.raw["projectile"]["explosive-cannon-projectile"].final_action.action_delivery.target_effects[2].action.action_delivery.target_effects[1].damage.amount = 750

-- explosive-rocket
data.raw["projectile"]["explosive-rocket"].action.action_delivery.target_effects[2].damage.amount = 125
data.raw["projectile"]["explosive-rocket"].action.action_delivery.target_effects[6].action.action_delivery.target_effects[1].damage.amount = 250

-- explosive-uranium-cannon-projectile
data.raw["projectile"]["explosive-uranium-cannon-projectile"].action.action_delivery.target_effects[1].damage.amount = 875
data.raw["projectile"]["explosive-uranium-cannon-projectile"].final_action.action_delivery.target_effects[2].action.action_delivery.target_effects[1].damage.amount = 787.5

-- grenade
data.raw["projectile"]["grenade"].action[2].action_delivery.target_effects[1].damage.amount = 87.5

-- piercing-shotgun-pellet
data.raw["projectile"]["piercing-shotgun-pellet"].action.action_delivery.target_effects[2].damage.amount = 30

-- rocket
data.raw["projectile"]["rocket"].action.action_delivery.target_effects[2].damage.amount = 500

-- shotgun-pellet
data.raw["projectile"]["shotgun-pellet"].action.action_delivery.target_effects[2].damage.amount = 20

-- uranium-cannon-projectile
data.raw["projectile"]["uranium-cannon-projectile"].action.action_delivery.target_effects[1].damage.amount = 5000
data.raw["projectile"]["uranium-cannon-projectile"].action.action_delivery.target_effects[2].damage.amount = 500

-- proxy-container
data.raw["proxy-container"]["proxy-container"].max_health = 250

-- pump
data.raw["pump"]["pump"].max_health = 450
data.raw["pump"]["pump"].pumping_speed = 50

-- radar
data.raw["radar"]["radar"].max_distance_of_nearby_sector_revealed = 8
data.raw["radar"]["radar"].max_distance_of_sector_revealed = 19
data.raw["radar"]["radar"].max_health = 625

-- rail-chain-signal
data.raw["rail-chain-signal"]["rail-chain-signal"].max_health = 250

-- rail-ramp
data.raw["rail-ramp"]["rail-ramp"].max_health = 5000

-- rail-signal
data.raw["rail-signal"]["rail-signal"].max_health = 250

-- rail-support
data.raw["rail-support"]["rail-support"].max_health = 2500

-- heating-tower
data.raw["reactor"]["heating-tower"].consumption = "100MW"
data.raw["reactor"]["heating-tower"].max_health = 1250

-- nuclear-reactor
data.raw["reactor"]["nuclear-reactor"].consumption = "100MW"
data.raw["reactor"]["nuclear-reactor"].max_health = 1250

-- repair-pack
data.raw["repair-tool"]["repair-pack"].durability = 1800

-- roboport
data.raw["roboport"]["roboport"].charging_energy = "1250kW"
data.raw["roboport"]["roboport"].max_health = 1250

-- personal-roboport-equipment
data.raw["roboport-equipment"]["personal-roboport-equipment"].charging_energy = "2500kW"
data.raw["roboport-equipment"]["personal-roboport-equipment"].charging_station_count = 7
data.raw["roboport-equipment"]["personal-roboport-equipment"].energy_source.input_flow_limit = "8750kW"
data.raw["roboport-equipment"]["personal-roboport-equipment"].robot_limit = 25

-- personal-roboport-mk2-equipment
data.raw["roboport-equipment"]["personal-roboport-mk2-equipment"].charging_energy = "2500kW"
data.raw["roboport-equipment"]["personal-roboport-mk2-equipment"].charging_station_count = 9
data.raw["roboport-equipment"]["personal-roboport-mk2-equipment"].robot_limit = 62

-- rocket-silo
data.raw["rocket-silo"]["rocket-silo"].arm_01_back_animation.animation_speed = 0.6
data.raw["rocket-silo"]["rocket-silo"].arm_02_right_animation.animation_speed = 0.6
data.raw["rocket-silo"]["rocket-silo"].arm_03_front_animation.animation_speed = 0.6
data.raw["rocket-silo"]["rocket-silo"].crafting_speed = 2.5
data.raw["rocket-silo"]["rocket-silo"].max_health = 12500

-- rocket-silo-rocket
data.raw["rocket-silo-rocket"]["rocket-silo-rocket"].engine_starting_speed = 0.00984848484848485
data.raw["rocket-silo-rocket"]["rocket-silo-rocket"].rising_speed = 0.00416666666666667

-- selector-combinator
data.raw["selector-combinator"]["selector-combinator"].max_health = 375

-- poison-cloud
data.raw["smoke-with-trigger"]["poison-cloud"].action.action_delivery.target_effects.action.action_delivery.target_effects.damage.amount = 20

-- solar-panel
data.raw["solar-panel"]["solar-panel"].max_health = 500
data.raw["solar-panel"]["solar-panel"].production = "150kW"

-- solar-panel-equipment
data.raw["solar-panel-equipment"]["solar-panel-equipment"].power = "75kW"

-- space-platform-hub
data.raw["space-platform-hub"]["space-platform-hub"].max_health = 12500

-- big-stomper-pentapod-leg
data.raw["spider-leg"]["big-stomper-pentapod-leg"].max_health = 250

-- big-strafer-pentapod-leg
data.raw["spider-leg"]["big-strafer-pentapod-leg"].max_health = 250

-- medium-stomper-pentapod-leg
data.raw["spider-leg"]["medium-stomper-pentapod-leg"].max_health = 250

-- medium-strafer-pentapod-leg
data.raw["spider-leg"]["medium-strafer-pentapod-leg"].max_health = 250

-- small-stomper-pentapod-leg
data.raw["spider-leg"]["small-stomper-pentapod-leg"].max_health = 250

-- small-strafer-pentapod-leg
data.raw["spider-leg"]["small-strafer-pentapod-leg"].max_health = 250

-- spidertron-leg-1
data.raw["spider-leg"]["spidertron-leg-1"].max_health = 250

-- spidertron-leg-2
data.raw["spider-leg"]["spidertron-leg-2"].max_health = 250

-- spidertron-leg-3
data.raw["spider-leg"]["spidertron-leg-3"].max_health = 250

-- spidertron-leg-4
data.raw["spider-leg"]["spidertron-leg-4"].max_health = 250

-- spidertron-leg-5
data.raw["spider-leg"]["spidertron-leg-5"].max_health = 250

-- spidertron-leg-6
data.raw["spider-leg"]["spidertron-leg-6"].max_health = 250

-- spidertron-leg-7
data.raw["spider-leg"]["spidertron-leg-7"].max_health = 250

-- spidertron-leg-8
data.raw["spider-leg"]["spidertron-leg-8"].max_health = 250

-- spidertron
data.raw["spider-vehicle"]["spidertron"].inventory_size = 200
data.raw["spider-vehicle"]["spidertron"].max_health = 7500

-- express-splitter
data.raw["splitter"]["express-splitter"].max_health = 475

-- fast-splitter
data.raw["splitter"]["fast-splitter"].max_health = 450

-- splitter
data.raw["splitter"]["splitter"].max_health = 425

-- turbo-splitter
data.raw["splitter"]["turbo-splitter"].max_health = 475

-- bioflux-speed-regen-sticker
data.raw["sticker"]["bioflux-speed-regen-sticker"].damage_per_tick.amount = -10
data.raw["sticker"]["bioflux-speed-regen-sticker"].duration_in_ticks = 2400

-- bioflux-speed-regen-sticker-behind
data.raw["sticker"]["bioflux-speed-regen-sticker-behind"].duration_in_ticks = 2400

-- electric-mini-stun
data.raw["sticker"]["electric-mini-stun"].duration_in_ticks = 100

-- factorio-light-fire-sticker
data.raw["sticker"]["factorio-light-fire-sticker"].damage_per_tick.amount = 41.6666666666667
data.raw["sticker"]["factorio-light-fire-sticker"].duration_in_ticks = 4500

-- jellynut-speed-sticker
data.raw["sticker"]["jellynut-speed-sticker"].duration_in_ticks = 1800

-- jellynut-speed-sticker-behind
data.raw["sticker"]["jellynut-speed-sticker-behind"].duration_in_ticks = 1800

-- shotgun-impact-sticker
data.raw["sticker"]["shotgun-impact-sticker"].duration_in_ticks = 250

-- slowdown-sticker
data.raw["sticker"]["slowdown-sticker"].duration_in_ticks = 4500

-- stun-sticker
data.raw["sticker"]["stun-sticker"].duration_in_ticks = 450

-- tesla-turret-slow
data.raw["sticker"]["tesla-turret-slow"].duration_in_ticks = 300

-- tesla-turret-stun
data.raw["sticker"]["tesla-turret-stun"].duration_in_ticks = 75

-- yumako-regen-sticker
data.raw["sticker"]["yumako-regen-sticker"].damage_per_tick.amount = -10
data.raw["sticker"]["yumako-regen-sticker"].duration_in_ticks = 1800

-- yumako-regen-sticker-behind
data.raw["sticker"]["yumako-regen-sticker-behind"].duration_in_ticks = 1800

-- storage-tank
data.raw["storage-tank"]["storage-tank"].fluid_box.volume = 62500
data.raw["storage-tank"]["storage-tank"].max_health = 1250

-- straight-rail
data.raw["straight-rail"]["straight-rail"].max_health = 500

-- handheld-flamethrower-fire-stream
data.raw["stream"]["handheld-flamethrower-fire-stream"].action[1].action_delivery.target_effects[1].sticker = "factorio-light-fire-sticker"
data.raw["stream"]["handheld-flamethrower-fire-stream"].action[1].action_delivery.target_effects[2].damage.amount = 5
data.raw["stream"]["handheld-flamethrower-fire-stream"].action[2].action_delivery.target_effects[1].entity_name = "factorio-light-fire-flame"

-- tank-flamethrower-fire-stream
data.raw["stream"]["tank-flamethrower-fire-stream"].action[1].action_delivery.target_effects[1].damage.amount = 17.5

-- thruster
data.raw["thruster"]["thruster"].max_health = 750

-- train-stop
data.raw["train-stop"]["train-stop"].max_health = 625

-- express-transport-belt
data.raw["transport-belt"]["express-transport-belt"].max_health = 425

-- fast-transport-belt
data.raw["transport-belt"]["fast-transport-belt"].max_health = 400

-- transport-belt
data.raw["transport-belt"]["transport-belt"].max_health = 375

-- turbo-transport-belt
data.raw["transport-belt"]["turbo-transport-belt"].max_health = 425

-- express-underground-belt
data.raw["underground-belt"]["express-underground-belt"].max_health = 425

-- fast-underground-belt
data.raw["underground-belt"]["fast-underground-belt"].max_health = 400

-- turbo-underground-belt
data.raw["underground-belt"]["turbo-underground-belt"].max_health = 425

-- underground-belt
data.raw["underground-belt"]["underground-belt"].max_health = 375

-- one-way-valve
data.raw["valve"]["one-way-valve"].flow_rate = 50
data.raw["valve"]["one-way-valve"].max_health = 250

-- overflow-valve
data.raw["valve"]["overflow-valve"].flow_rate = 50
data.raw["valve"]["overflow-valve"].max_health = 250

-- top-up-valve
data.raw["valve"]["top-up-valve"].flow_rate = 50
data.raw["valve"]["top-up-valve"].max_health = 250

-- stone-wall
data.raw["wall"]["stone-wall"].max_health = 875
