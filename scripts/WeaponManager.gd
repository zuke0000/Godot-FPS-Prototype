extends Node3D

enum WEAPON_SLOTS {MACHETE, MACHINE_GUN, SHOTGUN, ROCKET_LAUNCHER}
var slots_unlocked = {
	WEAPON_SLOTS.MACHETE: true,
	WEAPON_SLOTS.MACHINE_GUN: false,
	WEAPON_SLOTS.SHOTGUN: false,
	WEAPON_SLOTS.ROCKET_LAUNCHER: false,
}

var current_slot = 0
var current_weapon = null
var fire_point = Node3D
var bodies_to_exclude : Array = []
var weapons
var alert_area_hearing
var alert_area_los

signal ammo_changed

func _ready():
	weapons = $Weapons.get_children()
	alert_area_hearing = $AlertAreaHearing
	alert_area_los = $AlertAreaLos
	
func init(_fire_point: Node3D, _bodies_to_exclude: Array):
	fire_point = _fire_point
	bodies_to_exclude = _bodies_to_exclude
	for weapon in weapons:
		if weapon.has_method("init"):
			weapon.init(_fire_point, _bodies_to_exclude)
	
	# hardcoded fire alert values. Should be an export variable instead
	weapons[WEAPON_SLOTS.MACHINE_GUN].fired.connect(alert_nearby_enemies)
	weapons[WEAPON_SLOTS.SHOTGUN].fired.connect(alert_nearby_enemies)
	weapons[WEAPON_SLOTS.ROCKET_LAUNCHER].fired.connect(alert_nearby_enemies)
	switch_to_weapon_slot(WEAPON_SLOTS.MACHETE) # hardcoded for now
	
	for weapon in weapons:
		weapon.fired.connect(emit_ammo_changed_signal)
	
func attack(attack_input_just_pressed: bool, attack_input_held: bool):
	if current_weapon.has_method("attack"):
		current_weapon.attack(attack_input_just_pressed, attack_input_held)	
	
func switch_to_next_weapon():
	# don't allow weapon to switch if attacking
	current_weapon = get_current_weapon()
	if current_weapon.can_attack == false:
		return
	
	current_slot = (current_slot + 1) % slots_unlocked.size()
	if (!slots_unlocked[current_slot]):
		switch_to_next_weapon()
	else:
		switch_to_weapon_slot(current_slot)

func switch_to_last_weapon():
	# don't allow weapon to switch if attacking
	current_weapon = get_current_weapon()
	if current_weapon.can_attack == false:
		return
		
	current_slot = posmod((current_slot -1 ), slots_unlocked.size()) # posmod so there's no negatives
	if (!slots_unlocked[current_slot]):
		switch_to_last_weapon()
	else:
		switch_to_weapon_slot(current_slot)

func switch_to_weapon_slot(slot_index: int):
	if slot_index < 0 or slot_index >= slots_unlocked.size(): # nothing if trying to use wrong number
		return
	if !slots_unlocked[current_slot]:
		return
	disable_all_weapons()
	current_weapon = weapons[slot_index]
	if current_weapon.has_method("set_active"):
		current_weapon.set_active()
	else:
		current_weapon.show() # show anyway even if it cant be active

func get_current_weapon():
	var current_weapon = weapons[current_slot]
	return current_weapon
	

func disable_all_weapons():
	for weapon in weapons:
		if weapon.has_method("set_inactive"):
			weapon.set_inactive()
		else:
			weapon.hide()

func alert_nearby_enemies():
	# do close circle check. Enemies will hear if close even through walls
	var nearby_enemies = alert_area_los.get_overlapping_bodies()
	for nearby_enemy in nearby_enemies:
		if nearby_enemy.has_method("alert"):
			nearby_enemy.alert()
	
	# do hearing check. Alert if player is shooting and far away
	nearby_enemies = alert_area_hearing.get_overlapping_bodies()
	for nearby_enemy in nearby_enemies:
		if nearby_enemy.has_method("alert"):
			nearby_enemy.alert(false)


# TODO: I don't like this hardcoded function. Works for now but
# will be messy if I have a lot of pickup types
func get_pickup(pickup_type, ammo):
	
	
	match pickup_type:
		
		Pickup.PICKUP_TYPE.MACHINE_GUN:
			if !slots_unlocked[WEAPON_SLOTS.MACHINE_GUN]:
				slots_unlocked[WEAPON_SLOTS.MACHINE_GUN] = true
				switch_to_weapon_slot(WEAPON_SLOTS.MACHINE_GUN)
			weapons[WEAPON_SLOTS.MACHINE_GUN].ammo += ammo
			
		Pickup.PICKUP_TYPE.MACHINE_GUN_AMMO:
			#if slots_unlocked[WEAPON_SLOTS.MACHINE_GUN]:
			weapons[WEAPON_SLOTS.MACHINE_GUN].ammo += ammo
			
		Pickup.PICKUP_TYPE.SHOTGUN:
			if !slots_unlocked[WEAPON_SLOTS.SHOTGUN]:
				slots_unlocked[WEAPON_SLOTS.SHOTGUN] = true
				switch_to_weapon_slot(WEAPON_SLOTS.SHOTGUN)
			weapons[WEAPON_SLOTS.SHOTGUN].ammo += ammo
			
		Pickup.PICKUP_TYPE.SHOTGUN_AMMO:
			#if slots_unlocked[WEAPON_SLOTS.SHOTGUN]:
			weapons[WEAPON_SLOTS.SHOTGUN].ammo += ammo

		Pickup.PICKUP_TYPE.ROCKET_LAUNCHER:
			if !slots_unlocked[WEAPON_SLOTS.ROCKET_LAUNCHER]:
				slots_unlocked[WEAPON_SLOTS.ROCKET_LAUNCHER] = true
				switch_to_weapon_slot(WEAPON_SLOTS.ROCKET_LAUNCHER)
			weapons[WEAPON_SLOTS.ROCKET_LAUNCHER].ammo += ammo
		
		Pickup.PICKUP_TYPE.ROCKET:
			#if !slots_unlocked[WEAPON_SLOTS.ROCKET_LAUNCHER]:
			weapons[WEAPON_SLOTS.ROCKET_LAUNCHER].ammo += ammo
			
func emit_ammo_changed_signal():
	emit_signal('ammo_changed', current_weapon.ammo)
	print('Got pickup for slot: ', current_slot, ' ammo: ', current_weapon.ammo)
	
	
	
	
	
