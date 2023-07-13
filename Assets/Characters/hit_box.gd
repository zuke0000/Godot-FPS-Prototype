extends Area3D

class_name HitBox

@export var weak_spot = false
@export var critical_damage_multiplier = 2
@onready var head_node = get_node("../../Head")
@onready var head_node_collision = get_node("../../Head/HitBox/CollisionShape3D")

signal hitbox_hurt
signal hitbox_looked_at

func hurt(damage: int, dir: Vector3, pos = Vector3.ZERO):
	if weak_spot:
		emit_signal("hitbox_hurt", damage * critical_damage_multiplier, dir, pos)
	else:
		emit_signal("hitbox_hurt", damage, dir, pos)

func get_head_pos():
	if head_node:
		return head_node_collision.global_transform.origin
	else:
		return false

func looking_at():
	emit_signal("hitbox_looked_at")

