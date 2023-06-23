extends Area3D

class_name HitBox

@export var weak_spot = false
@export var critical_damage_multiplier = 2

signal hitbox_hurt

func hurt(damage: int, dir: Vector3, pos = Vector3.ZERO):
	if weak_spot:
		emit_signal("hitbox_hurt", damage * critical_damage_multiplier, dir, pos)
	else:
		emit_signal("hitbox_hurt", damage, dir, pos)
