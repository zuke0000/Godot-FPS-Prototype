extends Node3D

@export var turn_speed = 100.0 # how much to turn
@export var has_turn_threshold := false
@export var turn_threshold := 60 # max degrees allowed to turn

func face_point(point: Vector3, delta: float):
		var l_point = to_local(point)
		l_point.y = 0.0
		var turn_direction = sign(l_point.x) # left or right
		var turn_amount = deg_to_rad(turn_speed * delta) # how much to turn this frame
		
		
		#prevent jittering
		var angle = Vector3.FORWARD.angle_to(l_point) # 
		if angle < turn_amount:
			turn_amount = angle
		
		if rad_to_deg(angle) > turn_threshold and has_turn_threshold:
			return
		#$"..".rotate(Vector3.UP, -turn_amount * turn_direction)
		rotate_object_local(Vector3.UP, -turn_amount * turn_direction)

func face_point_correct(point: Vector3, delta: float):
	var l_point = to_local(point)
	l_point.y = 0.0
	var turn_dir = sign(l_point.x)
	var turn_amnt = deg_to_rad(turn_speed * delta)
	var angle = Vector3.FORWARD.angle_to(l_point)
	
	if angle < turn_amnt:
		turn_amnt = angle
	rotate_object_local(Vector3.UP, -turn_amnt * turn_dir)

func is_facing_target(target_point: Vector3):
	var l_target_pos = to_local(target_point)
	return l_target_pos.z < 0 and abs(l_target_pos.x) < 1.0
