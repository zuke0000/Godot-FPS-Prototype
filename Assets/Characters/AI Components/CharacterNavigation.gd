extends Node3D

@onready var navigation_agent = $NavigationAgent3D
@onready var character_mover = $"../CharacterMover"
#@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var body_to_move = $".."

func follow_target(delta, target):
	var target_position = target.global_transform.origin
	navigation_agent.set_target_position(target_position)
	var our_position = global_transform.origin
	var next_position = navigation_agent.get_next_path_position()
	var new_velocity = (next_position - our_position).normalized()
	#velocity = new_velocity
	#move_and_slide()
	# var dir = next_position - our_position

	var dir = our_position.direction_to(next_position)
	dir.y = 0
	character_mover.set_move_vec(dir)
	#body_to_move.face_direction(dir, delta)

func no_target(delta):
	var our_position = global_transform.origin
	var dir = our_position.direction_to(our_position)
	dir.y = 0
	character_mover.set_move_vec(dir)
