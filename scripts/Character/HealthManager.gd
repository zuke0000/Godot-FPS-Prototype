extends Node3D

signal emit_max_health_and_shield
signal dead
signal healthbar_hurt
signal healed
signal health_changed
signal shield_changed
signal gibbed
@export_category("Values")
@export var max_health := 100.0
@export var max_shield := 0.0
@export var shield_gate := false # TODO, set an invincible timer when shield pops
@export var gib_at = -10 # gib if overdamaged to -10
var current_health = 1.0
var current_shield = 1.0

@export_category("Regeneration")
@export var should_regen := false
@export var health_cooldown := 2.0 # time to start regening if no damage taken
@export var shield_cooldown := 6.0
@export var shield_gap_cooldown := 3.0 # cooldown to wait if shield is 0 before it can regen again
@export var health_regen_speed := 3.0 # health regen per second
@export var shield_regen_speed := 3.0 # shield regen per second
var regen_health := false # counts up to cooldown, allows regen at this point
var regen_shield := false
var shield_gap := true
var regen_timer := 0.0

@export_category("Scenes")
@export var blood_spray = preload("res://effects/blood_spray.tscn") 
@export var gibs = preload("res://effects/gibs.tscn")

func _ready():
	#print('readied')
	current_health = max_health
	current_shield = max_shield
	emit_signal("health_changed", current_health)
	emit_signal("shield_changed", current_shield)
	emit_signal("emit_max_health_and_shield", max_health, max_shield)

func init(_max_health = max_health, _max_shield = max_shield):
	#print('inited')
	current_health = _max_health
	current_shield = _max_shield
	emit_signal("health_changed", current_health)
	emit_signal("shield_changed", current_shield)

func _physics_process(delta):
	regen(delta)
	manage_cooldowns(delta)
	
func hurt_shield_or_health(_damage):
	if current_shield <= 0.0:
		current_health -= _damage
		return
	
	var remainder = 0.0 # carries over to health if shield is down
	current_shield -= _damage
	emit_signal("shield_changed", max(0.0, current_shield))
	if current_shield <= 0.0:
		print('no shield')
		remainder = abs(current_shield)
		current_shield = 0.0
		current_health -= remainder
	
func hurt(damage: int, dir: Vector3, pos = position, damage_type="normal"):
	spawn_blood(dir, pos)
	
	if (current_health <=0):
		return
	#current_health -= damage
	hurt_shield_or_health(damage)
	if current_health <= gib_at:
		spawn_gibs(pos)
		emit_signal("gibbed")
	if current_health <=0:
		emit_signal("dead")
	#emit_signal("hurt") # signal not in use
	#emit_signal("hurt")
	emit_signal("health_changed", current_health)
	emit_signal("shield_changed", current_shield)
	#print('hurt ', damage, 'current health ', current_health)
	if max_shield > 0.0:
		print('current shield: ', current_shield)
	reset_regen_cooldown()

func heal(amount : float):
	if current_health <= 0:
		return
	current_health += amount
	current_health = min(max_health, current_health)
	emit_signal("healed")
	emit_signal("health_changed", current_health)

func heal_shield(amount : float):
	current_shield += amount
	current_shield = min(max_shield, current_shield)
	emit_signal("healed")
	emit_signal("shield_changed", current_shield)

func spawn_blood(dir, pos):
	var blood_spray_instance = blood_spray.instantiate()
	blood_spray_instance.position = pos # move effect to position	
	get_tree().get_root().add_child(blood_spray_instance)
		
	if dir.angle_to(Vector3.UP) < 0.00005: # dont rotate if shooting floor
		return
	if dir.angle_to(Vector3.DOWN) < 0.00005: # shooting ceiling
		blood_spray_instance.rotate(Vector3.RIGHT, PI)
		return
		
	var y = dir
	var x = y.cross(Vector3.UP)
	var z = x.cross(y)
		
	blood_spray_instance.global_transform.basis = Basis(x,y,z) # orient correct  way

func spawn_gibs(pos):
	var gibs_instance = gibs.instantiate()
	gibs_instance.position = pos 
	get_tree().get_root().add_child(gibs_instance)
	gibs_instance.enable_gibs()

func get_pickup(pickup_type, ammo):
	match pickup_type:
		Pickup.PICKUP_TYPE.HEALTH:
			heal(ammo)

func regen(delta):
	if should_regen and regen_health:
		heal(health_regen_speed * delta)
	if should_regen and regen_shield:
		heal_shield(shield_regen_speed * delta)
	

# timer goes up, changes based on if shield was popped or not
func manage_cooldowns(delta):
	if !should_regen:
		return
	regen_timer = min(regen_timer+delta, health_cooldown+shield_cooldown)
	if regen_timer >= health_cooldown:
		regen_health = true
	if regen_timer >= health_cooldown+shield_gap_cooldown:
		regen_shield = true
	if regen_timer >= shield_cooldown and current_shield > 0.0:
		regen_shield = true

# reset cooldowns when hurt
func reset_regen_cooldown():
	regen_health = false
	regen_shield = false
	regen_timer = 0.0
	
