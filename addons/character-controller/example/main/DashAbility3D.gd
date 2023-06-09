extends MovementAbility3D
class_name DashAbility3D

## Simple ability that adds a vertical impulse when actived (Jump)

## Jump/Impulse height
@export var cooldown := 1.5
@export var speed_multiplier := 4
@export var can_dash := true
@export var dash_speed_limit := 30
@export var dash_count := 2

var current_dash_count = dash_count
var current_dash_speed_limit = dash_speed_limit

## Change vertical velocity of [CharacterController3D]
func apply(velocity : Vector3, speed : float, is_on_floor : bool, direction : Vector3, _delta : float) -> Vector3:	
	if is_actived() and can_dash and current_dash_count > 0:
		
		var input_axis = Input.get_vector("move_backward", "move_forward", "move_left", "move_right")
		#var direction = _direction_input(input_axis)
		GlobalFunctions.closest([1,2],0)
		#print(input_axis)
		# TODO: player should dash forward or backward if no input is given to direction
		direction[2] = input_axis[0] if direction[2] == 0 else direction[2]
		# dash forward by default if no inputs
		#input_axis[0] = 1 if (input_axis[0] == 0 and input_axis[1] == 1) else input_axis[1]
		
		#velocity.x = closest([speed_multiplier * velocity.x, sign(velocity.x * input_axis[0]) * dash_speed_limit], 0)
		#velocity.z = closest([speed_multiplier * velocity.z, sign(velocity.z * input_axis[1]) * dash_speed_limit], 0)
		velocity.x = (dash_speed_limit * (direction[0])) 
		velocity.z = (dash_speed_limit * (direction[2])) 

		if (velocity.y > -1 and velocity.y < 0):
			print('mini jump')
			velocity.y = 5
		#can_dash = false
		current_dash_count -= 1
		dash_cooldown(cooldown)
		return velocity
		
		
	return velocity
	

	
func dash_cooldown(cooldown):
	#print('starting cooldown')
	await get_tree().create_timer(cooldown).timeout
	#print('ending cooldown')
	#can_dash = true
	current_dash_count = min(dash_count, current_dash_count+1)


