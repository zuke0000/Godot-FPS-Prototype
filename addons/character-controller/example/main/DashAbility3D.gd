extends MovementAbility3D
class_name DashAbility3D

## Simple ability that adds a vertical impulse when actived (Jump)

## Jump/Impulse height
@export var cooldown := 1.5
@export var speed_multiplier := 4
@export var can_dash := true
@export var dash_speed_limit := 30
@export var dash_count := 2
var _direction_base_node : Node3D

var current_dash_count = dash_count
var current_dash_speed_limit = dash_speed_limit

## Change vertical velocity of [CharacterController3D]
func apply(velocity : Vector3, speed : float, is_on_floor : bool, direction : Vector3, _delta : float) -> Vector3:	
	if is_actived() and can_dash and current_dash_count > 0:
		
		# dash forward if no inputs
		if direction == Vector3(0,0,0):
			direction = _direction_input(Vector2(1,0), false, false, _direction_base_node)
			
		velocity.x = (dash_speed_limit * (direction[0])) 
		velocity.z = (dash_speed_limit * (direction[2])) 

		if (velocity.y > -1 and velocity.y < 0):
			#print('mini jump')
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

# for recalculating input
func _direction_input(input : Vector2, input_down : bool, input_up : bool, aim_node : Node3D) -> Vector3:
	var _direction = Vector3()
	#var aim = aim_node.get_global_transform().basis
	var aim = $"..".get_global_transform().basis
	if input.x >= 0.5:
		_direction -= aim.z
	if input.x <= -0.5:
		_direction += aim.z
	if input.y <= -0.5:
		_direction -= aim.x
	if input.y >= 0.5:
		_direction += aim.x
	# NOTE: For free-flying and swimming movements
		_direction.y = 0	
	return _direction.normalized()

