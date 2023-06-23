extends Node3D

signal dead
signal healthbar_hurt
signal healed
signal health_changed
signal gibbed

@export var max_health := 100
var current_health = 1

@export var gib_at = -10 # gib if overdamaged to -10

@export var blood_spray = preload("res://effects/blood_spray.tscn") 

func _ready():
	print('readied')
	current_health = max_health
	emit_signal("health_changed", current_health)

func init():
	print('inited')
	current_health = max_health
	emit_signal("health_changed", current_health)
#
func hurt(damage: int, dir: Vector3, pos = position, damage_type="normal", ):
	spawn_blood(dir, pos)
	if (current_health <=0):
		return
	current_health -= damage
	if current_health <= gib_at:
		pass
		#TODO make gib spawner
		emit_signal("gibbed")
	if current_health <=0:
		emit_signal("dead")
	#emit_signal("hurt") # signal not in use
	#emit_signal("hurt")
	emit_signal("health_changed", current_health)
	print('hurt ', damage, 'current health ', current_health)
	
func heal(amount : int):
	if current_health <= 0:
		return
	current_health += amount
	current_health = min(max_health, current_health)
	emit_signal("healed")
	emit_signal("health_changed", current_health)

func spawn_blood(dir, pos):
	var blood_spray_instance = blood_spray.instantiate()
	blood_spray_instance.global_transform.origin = pos # move effect to position	
	#blood_spray_instance.position = global_transform.origin
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
