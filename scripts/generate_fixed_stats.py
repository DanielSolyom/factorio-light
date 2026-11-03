"""Developer-only snapshot generator. Never runs inside Factorio.

Read an unmodified 2.1.24 Space Age data dump and independently measured
legendary engine getters. Emit literal per-prototype assignments for review.
Usage: python3 scripts/generate_fixed_stats.py BASE_DUMP LEGENDARY_REFERENCE
"""
import json, sys, math, re
from pathlib import Path
base=json.load(open(sys.argv[1])); ref=json.load(open(sys.argv[2])); changes={}
def setv(t,n,path,v):
 if (t,n) in {('fire','fire-flame'),('sticker','fire-sticker')}:n='factorio-light-'+n
 changes.setdefault((t,n),{})[path]=v
def energy(v,m):
 match=re.fullmatch(r'([\d.]+)([kMGT]?)([JW])',v)
 assert match,v
 return f'{float(match[1])*m:g}{match[2]}{match[3]}'
def scale(t,n,v,key,m):
 if key in v: setv(t,n,key,energy(v[key],m) if isinstance(v[key],str) else v[key]*m)
world={'asteroid','unit','unit-spawner','turret','spider-unit','segmented-unit','segment','tree','plant','simple-entity','simple-entity-with-owner','simple-entity-with-force','market','character'}
items={n:(t,v) for t,vs in base.items() for n,v in vs.items() if 'stack_size' in v}
placed={v['place_result'] for _,v in items.values() if v.get('place_result')}
entity_types={'combat-robot','construction-robot','logistic-robot','artillery-flare','spider-leg','rail-ramp','elevated-straight-rail','elevated-curved-rail-a','elevated-curved-rail-b','elevated-half-diagonal-rail','curved-rail-a','curved-rail-b','half-diagonal-rail','straight-rail'}
for n,r in ref['entity'].items():
 t=r['type']; v=base.get(t,{}).get(n)
 if not v or t in world or n.startswith(('crash-site','fulgoran-ruin')): continue
 if n not in placed and t not in entity_types: continue
 if 'max_health' in v: setv(t,n,'max_health',r['get_max_health'])
 direct={'get_crafting_speed':'crafting_speed','get_researching_speed':'researching_speed','get_inserter_rotation_speed':'rotation_speed','get_inserter_extension_speed':'extension_speed','get_max_distance_of_nearby_sector_revealed':'max_distance_of_nearby_sector_revealed','get_max_distance_of_sector_revealed':'max_distance_of_sector_revealed','get_supply_area_distance':'supply_area_distance','get_max_wire_distance':'maximum_wire_distance','get_pumping_speed':'pumping_speed','get_inventory_size_bonus':'inventory_size_bonus','get_attraction_range_elongation':'range_elongation','get_energy_distribution_efficiency':'efficiency','get_valve_flow_rate':'flow_rate'}
 for getter,field in direct.items():
  if getter in r and field in v and r[getter]!=v[field]:setv(t,n,field,r[getter])
 if t in {'container','logistic-container','cargo-wagon'} and v.get('quality_affects_inventory_size',True):scale(t,n,v,'inventory_size',2.5)
 if t=='fluid-wagon' and v.get('quality_affects_capacity',False):scale(t,n,v,'capacity',2.5)
 if t in {'locomotive','cargo-wagon','fluid-wagon','artillery-wagon'}:
  if v.get('quality_affects_max_speed',True) and 'get_max_speed' in r:setv(t,n,'max_speed',r['get_max_speed'])
  if t=='locomotive':scale(t,n,v,'max_power',2)
 if t=='mining-drill':setv(t,n,'resource_drain_rate_percent',v.get('resource_drain_rate_percent',100)/6)
 if t in {'construction-robot','logistic-robot'}:scale(t,n,v,'max_energy',6)
 if t=='solar-panel':scale(t,n,v,'production',2.5)
 if t=='accumulator':
  for k,m in [('buffer_capacity',6),('input_flow_limit',2.5),('output_flow_limit',2.5)]:setv(t,n,'energy_source.'+k,energy(v['energy_source'][k],m))
 if t in {'boiler','reactor'}:scale(t,n,v,'energy_consumption',2.5)
 if t=='generator':
  setv(t,n,'fluid_usage_per_tick',r['get_fluid_usage_per_tick'])
  if 'max_power_output' in v:scale(t,n,v,'max_power_output',2.5)
 if t=='fusion-generator':setv(t,n,'energy_source.output_flow_limit',energy(v['energy_source']['output_flow_limit'],2.5))
 if t=='beacon':
  scale(t,n,v,'energy_usage',1/6)
  setv(t,n,'distribution_effectivity',v.get('distribution_effectivity',0)+5*v.get('distribution_effectivity_bonus_per_quality_level',0))
 if t=='roboport':scale(t,n,v,'charging_energy',2.5)
 if t=='asteroid-collector':
  for key,inc in [('arm_count_base','arm_count_quality_scaling'),('arm_speed_base','arm_speed_quality_scaling'),('arm_angular_speed_cap_base','arm_angular_speed_cap_quality_scaling')]:
   # Speeds scale multiplicatively; arm count is additive.
   value=v[key]+5*v[inc] if key=='arm_count_base' else v[key]*(1+5*v[inc])
   setv(t,n,key,value)
  setv(t,n,'inventory_size',v['inventory_size']+5*v['inventory_size_quality_increase'])
  for key in ['passive_energy_usage','arm_energy_usage','arm_slow_energy_usage']:scale(t,n,v,key,1.5)
  # Radius is a distinct field, not the collision box.
  setv(t,n,'collection_radius',v.get('collection_radius',10)+5)
 if t=='lab' and v.get('uses_quality_drain_modifier',False):scale(t,n,v,'science_pack_drain_rate_percent',.95)
 if 'attack_parameters' in v and 'range' in v['attack_parameters']:
  setv(t,n,'attack_parameters.range',v['attack_parameters']['range']*1.5)
 if t=='combat-robot':
  if 'attack_parameters' in v:setv(t,n,'attack_parameters.damage_modifier',v['attack_parameters'].get('damage_modifier',1)*2.5)
  scale(t,n,v,'time_to_live',2.5)
# Equipment: explicit snapshot of each shipped equipment item.
for n,r in ref['equipment'].items():
 t=r['type'];v=base[t][n]
 for get,key in [('get_shield','max_shield_value'),('get_movement_bonus','movement_bonus'),('get_inventory_bonus','inventory_size_bonus')]:
  if get in r and key in v and v[key]!=r[get]:setv(t,n,key,r[get])
 if t == 'battery-equipment' and v.get('energy_source',{}).get('buffer_capacity'):
  setv(t,n,'energy_source.buffer_capacity',energy(v['energy_source']['buffer_capacity'],2.5))
 if t in {'generator-equipment','solar-panel-equipment'}:scale(t,n,v,'power',2.5)
 if t=='roboport-equipment':
  scale(t,n,v,'charging_energy',2.5)
  setv(t,n,'robot_limit',math.floor(v.get('robot_limit',0)*2.5))
  if v.get('charging_station_count_affected_by_quality'):setv(t,n,'charging_station_count',v['charging_station_count']+5)
 if t=='active-defense-equipment':
  setv(t,n,'attack_parameters.damage_modifier',v['attack_parameters'].get('damage_modifier',1)*2.5)
  setv(t,n,'attack_parameters.range',v['attack_parameters']['range']*1.5)
for n,(t,v) in items.items():
 if t=='module':
  effects=ref['item'][n]['get_module_effects']
  for k,x in effects.items():
   if k!='quality' and v.get('effect',{}).get(k)!=x:setv(t,n,'effect.'+k,x)
 if t=='armor':
  setv(t,n,'inventory_size_bonus',ref['item'][n]['get_inventory_size_bonus'])
  if v.get('equipment_grid'):
   grid=v['equipment_grid']
   for dim in ['width','height']:setv('equipment-grid',grid,dim,base['equipment-grid'][grid][dim]+5)
 if t=='repair-tool':setv(t,n,'durability',ref['item'][n]['get_durability'])
 if v.get('subgroup')=='science-pack':setv(t,n,'science_capacity',6)
 if t=='gun' and n!='pistol':setv(t,n,'attack_parameters.range',v['attack_parameters']['range']*1.5)
 for key in ['fuel_acceleration_multiplier','fuel_top_speed_multiplier']:
  if v.get(key,1)>1:setv(t,n,key,v[key]+5*v.get(key+'_quality_bonus',.3*(v[key]-1)))
# Player attack effects can cross projectile/beam/cloud prototypes. Follow only
# player ammo/capsules, then write each damage leaf once. Never scan enemy attacks.
entities={n:(t,v) for t,vs in base.items() for n,v in vs.items() if n in ref['entity'] or t == 'chain-active-trigger'}
seen=set()
def damage(t,n,value,path=''):
 if isinstance(value,dict):
  for key,x in value.items():
   p=(path+'.' if path else '')+key
   if key in {'damage','damage_per_tick'} and isinstance(x,dict) and 'amount' in x:setv(t,n,p+'.amount',x['amount']*2.5)
   elif key in {'projectile','beam','entity_name','sticker','explosion','chain','stream'} and isinstance(x,str) and x in entities:
    et,ev=entities[x]
    if x in {'fire-flame','fire-sticker'}:setv(t,n,p,'factorio-light-'+x)
    if et in {'projectile','artillery-projectile','beam','smoke-with-trigger','sticker','explosion','chain-active-trigger','stream','fire'} and x not in seen:
     seen.add(x);damage(et,x,ev)
   else:damage(t,n,x,p)
 elif isinstance(value,list):
  for i,x in enumerate(value):damage(t,n,x,path+f'[{i+1}]')
for n,(t,v) in items.items():
 if t in {'ammo','capsule'}:damage(t,n,v)
for t,vs in base.items():
 if t=='chain-active-trigger':
  for n,v in vs.items():
   if n in seen:setv(t,n,'fork_chance',min(1,v.get('fork_chance',0)+5*v.get('fork_chance_increase_per_quality_level',0)))
# Additional engine-observed values whose data field has a different name.
setv('storage-tank','storage-tank','fluid_box.volume',62500)
setv('fluid-wagon','fluid-wagon','capacity',125000)
for n in ['nuclear-reactor','heating-tower']:
 scale('reactor',n,base['reactor'][n],'consumption',2.5)
for t in ['fusion-reactor','fusion-generator']:
 scale(t,t,base[t][t],'max_fluid_usage',2.5)
setv('cargo-landing-pad','cargo-landing-pad','radar_range',9)
setv('ammo-turret','railgun-turret','energy_source.input_flow_limit','25MW')
for n in ['energy-shield-equipment','energy-shield-mk2-equipment','personal-roboport-equipment']:
 t=ref['equipment'][n]['type'];v=base[t][n]
 setv(t,n,'energy_source.input_flow_limit',energy(v['energy_source']['input_flow_limit'],2.5))
setv('belt-immunity-equipment','belt-immunity-equipment','energy_consumption','40kW')
setv('character','character','max_health',625)
for t in ['car','spider-vehicle']:
 for n,v in base[t].items():
  if v.get('equipment_grid'):
   g=v['equipment_grid']
   for dim in ['width','height']:setv('equipment-grid',g,dim,base['equipment-grid'][g][dim]+5)
silo=base['rocket-silo']['rocket-silo']
for key,modifier in [('rising_speed','rocket_rising_speed_modifier_per_quality_level'),('engine_starting_speed','rocket_engine_starting_speed_modifier_per_quality_level')]:
 scale('rocket-silo-rocket','rocket-silo-rocket',base['rocket-silo-rocket']['rocket-silo-rocket'],key,1+5*silo[modifier])
for arm in ['arm_01_back_animation','arm_02_right_animation','arm_03_front_animation']:
 setv('rocket-silo','rocket-silo',arm+'.animation_speed',silo[arm].get('animation_speed',1)*(1+5*silo['arms_speed_modifier_per_quality_level']))
for n in ['bioflux-speed-regen-sticker','bioflux-speed-regen-sticker-behind','electric-mini-stun',
          'fire-sticker','jellynut-speed-sticker','jellynut-speed-sticker-behind','shotgun-impact-sticker',
          'slowdown-sticker','stun-sticker','tesla-turret-slow','tesla-turret-stun',
          'yumako-regen-sticker','yumako-regen-sticker-behind']:
 setv('sticker',n,'duration_in_ticks',ref['entity'][n]['get_duration'])
for n,v in base['capsule'].items():
 attack=v.get('capsule_action',{}).get('attack_parameters',{})
 if attack.get('range',0)>0:setv('capsule',n,'capsule_action.attack_parameters.range',attack['range']*1.5)
setv('spider-vehicle','spidertron','inventory_size',200)
setv('chain-active-trigger','chain-tesla-turret-chain','fork_chance',0.30)
def lua(v):
 if isinstance(v,str):return json.dumps(v)
 if isinstance(v,bool):return str(v).lower()
 assert math.isfinite(v)
 return format(v,'.15g')
lines=['-- Fixed vanilla legendary values, reviewed against Factorio 2.1.24.',
       '-- Generated offline by scripts/generate_fixed_stats.py; NO quality changes,',
       '-- discovery, scaling loops or third-party prototype changes at game load.','']
lines += [
 'local player_fire = table.deepcopy(data.raw.fire["fire-flame"])',
 'player_fire.name = "factorio-light-fire-flame"',
 'local player_sticker = table.deepcopy(data.raw.sticker["fire-sticker"])',
 'player_sticker.name = "factorio-light-fire-sticker"',
 'data:extend({player_fire, player_sticker})', '']
for (t,n),fields in sorted(changes.items()):
 lines.append(f'-- {n}')
 for path,v in sorted(fields.items()):lines.append(f'data.raw[{json.dumps(t)}][{json.dumps(n)}].{path} = {lua(v)}')
 lines.append('')
Path('factorio-light/prototypes/fixed-stats.lua').write_text('\n'.join(lines))
print(f'{len(changes)} prototypes, {sum(map(len,changes.values()))} literal assignments')
