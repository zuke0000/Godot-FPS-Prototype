extends Node3D

var mouse_mov_x = 0
var mouse_mov_y = 0
var sway_threshold = 10
var sway_lerp = 0.025
"""
var sway_left : Vector3 = Vector3(0,-0.1,0)
var sway_right : Vector3 = Vector3(0,0.1,0)
var sway_normal : Vector3 = Vector3(0,0,0)

var sway_left_y : Vector3 = Vector3(0,0,-0.1)
var sway_right_y : Vector3 = Vector3(0,0,0.1)
var sway_normal_y : Vector3 = Vector3(0,0,0)
"""
var v = 0.1

@onready var weapon_manager = $".."

func _input(event):
	if event is InputEventMouseMotion:
		mouse_mov_x = -event.relative.x
		mouse_mov_y = -event.relative.y

# keep an eye on this incase it causes performance issues
func _process(delta):
	#weapon_manager.rotation = Vector3(0.25,0,0)
	#weapon_manager.global_transform.origin = temp_origin
	#weapon_manager.rotation = $"../../../..".rotation
	
	if (abs(mouse_mov_x) > sway_threshold) or (abs(mouse_mov_y) > sway_threshold):
		var left_right = sign(mouse_mov_x) * v
		var up_down = sign(mouse_mov_y) * v * 0.5
		var this_vec = Vector3(
			up_down,
			left_right,
			0
		)
		weapon_manager.rotation = lerp(weapon_manager.rotation, this_vec, sway_lerp)
	else:
		weapon_manager.rotation = lerp(weapon_manager.rotation, Vector3(0,0,0), sway_lerp)
	"""
	if mouse_mov_x != null:
		if mouse_mov_x > sway_threshold:
			weapon_manager.rotation = lerp(weapon_manager.rotation,sway_left, sway_lerp)
		elif mouse_mov_x < -sway_threshold:
			weapon_manager.rotation = lerp(weapon_manager.rotation,sway_right, sway_lerp)
		else:
			weapon_manager.rotation = lerp(weapon_manager.rotation,sway_normal, sway_lerp)
	
	if mouse_mov_y != null:
		if mouse_mov_y > sway_threshold:
			weapon_manager.rotation = lerp(weapon_manager.rotation,sway_left_y, sway_lerp)
		elif mouse_mov_y < -sway_threshold:
			weapon_manager.rotation = lerp(weapon_manager.rotation,sway_right_y, sway_lerp)
		else:
			weapon_manager.rotation = lerp(weapon_manager.rotation,sway_normal_y, sway_lerp)
"""
