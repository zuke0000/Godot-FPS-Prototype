extends MovementAbility3D
class_name DoubleJumpAbility3D

## Simple ability that adds a vertical impulse when actived (Jump)

## Jump/Impulse height
@export var height := 10
@export var double_jumps := 1
@export var speed_multiplier := 1.5
@export var speed_limit := 30
var current_double_jumps = double_jumps

## Change vertical velocity of [CharacterController3D]
func apply(velocity : Vector3, speed : float, is_on_floor : bool, direction : Vector3, _delta : float) -> Vector3:
	
	if is_actived() and current_double_jumps > 0:
		velocity.y = height
		velocity.x *= speed_multiplier
		velocity.z *= speed_multiplier
		current_double_jumps -= 1
	if (is_on_floor):
		current_double_jumps = double_jumps
	return velocity

