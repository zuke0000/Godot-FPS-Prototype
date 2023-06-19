extends Node3D

enum WEAPON_SLOTS {MACHETE, MACHINE_GUN, SHOTGUN, ROCKET_LAUNCHER}
var slots_unlocked = {
	WEAPON_SLOTS.MACHETE: true,
	WEAPON_SLOTS.MACHINE_GUN: true,
	WEAPON_SLOTS.SHOTGUN: true,
	WEAPON_SLOTS.ROCKET_LAUNCHER: true,
}

var current_slot = 0
var current_weapon = null
var fire_point = Node3D
var bodies_to_exclude : Array = []
var weapons
var alert_area_hearing
var alert_area_los

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
	
	weapons[WEAPON_SLOTS.MACHINE_GUN].fired.connect(alert_nearby_enemies)
	weapons[WEAPON_SLOTS.SHOTGUN].fired.connect(alert_nearby_enemies)
	weapons[WEAPON_SLOTS.ROCKET_LAUNCHER].fired.connect(alert_nearby_enemies)
	
	switch_to_weapon_slot(WEAPON_SLOTS.MACHETE)
	
	
func attack(attack_input_just_pressed: bool, attack_input_held: bool):
	if current_weapon.has_method("attack"):
		current_weapon.attack(attack_input_just_pressed, attack_input_held)	
	
func switch_to_next_weapon():
	current_slot = (current_slot + 1) % slots_unlocked.size()
	if (!slots_unlocked[current_slot]):
		switch_to_next_weapon()
	else:
		switch_to_weapon_slot(current_slot)

func switch_to_last_weapon():
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
