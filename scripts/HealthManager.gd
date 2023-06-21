extends Node3D

signal dead
signal healthbar_hurt
signal healed
signal health_changed
signal gibbed

@export var max_health := 100
var current_health = 1

@export var gib_at = -10 # gib if overdamaged to -10

func _ready():
	print('readied')
	current_health = max_health
	emit_signal("health_changed", current_health)

func init():
	print('inited')
	current_health = max_health
	emit_signal("health_changed", current_health)
#
func hurt(damage: int, dir: Vector3, damage_type="normal"):
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

