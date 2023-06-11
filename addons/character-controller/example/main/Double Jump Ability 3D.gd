extends MovementAbility3D
class_name DoubleJumpAbility3D

## Simple ability that adds a vertical impulse when actived (Jump)

## Jump/Impulse height
@export var height := 10
@export var double_jumps := 1
@export var speed_multiplier := 1.5
@export var speed_limit := 30
@export var speed_minimum := 10
var current_double_jumps = double_jumps

## Change vertical velocity of [CharacterController3D]
func apply(velocity : Vector3, speed : float, is_on_floor : bool, direction : Vector3, _delta : float) -> Vector3:
	if is_actived() and current_double_jumps > 0:
		velocity.y = height
		velocity.x = GlobalFunctions.closest([speed_multiplier*velocity.x, speed_limit *direction[0] + (speed_multiplier*velocity.x)])
		velocity.z = GlobalFunctions.closest([speed_multiplier*velocity.z, speed_limit *direction[2] + (speed_multiplier*velocity.z)])
		#velocity.x = (speed_limit * (direction[0])) 
		#velocity.z = (speed_limit * (direction[2])) 
		
		print(velocity.x, velocity.z)
		current_double_jumps -= 1
	if (is_on_floor):
		current_double_jumps = double_jumps
	return velocity

