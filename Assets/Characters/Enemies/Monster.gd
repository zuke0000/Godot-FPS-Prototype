extends CharacterBody3D

enum STATES {IDLE, CHASE, ATTACK, DEAD}
var current_state = STATES.IDLE
@onready var animation_player = $Graphics/AnimationPlayer
@onready var health_manager = $HealthManager
@onready var character_mover = $CharacterMover
@onready var navigation_agent = $NavigationAgent3D
var player = null
@export var sight_angle = 45 # enemy can see 45 degrees left and right to spot the player
@export var turn_speed := 360 #360 degrees per second

@export var attack_range = 2.0 # range of 2 meters
@export var attack_rate = 1
@export var attack_speed_multiplier := 1.25
var attack_timer : Timer
var can_attack = true


func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.timeout.connect(finish_attack)
	attack_timer.one_shot = true
	add_child(attack_timer)
	player = get_tree().get_nodes_in_group("player")[0]
	# setup signals for each hitbox in the bone attach
	var bone_attachments = $Graphics/Armature/Skeleton3D.get_children()
	for bone_attachment in bone_attachments:
		for child in bone_attachment.get_children():
			if child is HitBox:
				child.hitbox_hurt.connect(hurt)
	set_state_idle() # idle when spawning
	health_manager.dead.connect(set_state_dead)
	character_mover = $CharacterMover
	character_mover.init(self)
	
	health_manager.gibbed.connect($Graphics.hide)


# generic state machine setup
func _process(delta):
	match current_state:
		STATES.IDLE:
			process_state_idle(delta)
		STATES.CHASE:
			process_state_chase(delta)
		STATES.ATTACK:
			process_state_attack(delta)
		STATES.DEAD:
			process_state_dead(delta)

func set_state_idle():
	current_state = STATES.IDLE
	animation_player.play('idle')

func set_state_chase():
	animation_player.play("walk", 0.2)
	current_state = STATES.CHASE

func set_state_attack():
	current_state = STATES.ATTACK

func set_state_dead():
	current_state = STATES.DEAD
	animation_player.play("die")
	character_mover.freeze()
	$CollisionShape3D.disabled = true

func process_state_idle(delta):
	if can_see_player():
		set_state_chase()

func process_state_chase(delta):
	if within_distance_of_player(attack_range) and has_los_player():
		set_state_attack()
	var player_position = player.global_transform.origin
	navigation_agent.set_target_position(player_position)
	var our_position = global_transform.origin
	var next_position = navigation_agent.get_next_path_position()
	var new_velocity = (next_position - our_position).normalized()
	#velocity = new_velocity
	#move_and_slide()
	
	# var dir = next_position - our_position
	var dir = our_position.direction_to(next_position)
	dir.y = 0
	character_mover.set_move_vec(dir)
	face_direction(dir, delta)
	

func process_state_attack(delta):
	character_mover.set_move_vec(Vector3.ZERO)
	# not necessay to face player
	face_direction(global_transform.origin.direction_to(player.global_transform.origin), delta)
	
	if can_attack:
		if !within_distance_of_player(attack_range) or !can_see_player():
			set_state_chase()
		else:	
			start_attack()
		
	
func process_state_dead(delta):
	pass
	
func hurt(damage: int, dir: Vector3, pos: Vector3):
	if current_state == STATES.IDLE:
		set_state_chase()
	health_manager.hurt(damage, dir, pos)

func start_attack():
	can_attack = false
	animation_player.play("attack", -1, attack_speed_multiplier)
	attack_timer.start()

func finish_attack():
	can_attack = true	

	
# returns true if no environment is between player and this monster
func has_los_player(): 
	var our_position = global_transform.origin + Vector3.UP
	var player_position = player.global_transform.origin + Vector3.UP
	
	var direct_state = get_world_3d().direct_space_state
	var Parameters = PhysicsRayQueryParameters3D.new()#(our_position, our_position - global_transform.basis.z * distance, (1 + 4), bodies_to_exclude)
	Parameters.from = our_position
	Parameters.to = player_position
	Parameters.exclude = []
	Parameters.collision_mask = 1 # Layers to collide with. 1: environment
	Parameters.hit_back_faces = true #
	Parameters.collide_with_areas = true # This was required for working with enemy hitboxes
	#Parameters.hit_from_inside = true
	
	var result = direct_state.intersect_ray(Parameters)
	
	if (result):
		return false
	return true

func can_see_player():
	var direction_to_player = global_transform.origin.direction_to(player.global_transform.origin)
	var facing_direction = global_transform.basis.z
	return rad_to_deg(facing_direction.angle_to(direction_to_player)) < sight_angle and has_los_player()
		
func face_direction(direction: Vector3, delta):
	var angle_diff = global_transform.basis.z.angle_to(direction)
	var turn_right = sign(global_transform.basis.x.dot(direction))
	if abs(angle_diff) < deg_to_rad(turn_speed) * delta:
		rotation.y = (atan2(direction.x, direction.z))
	else:
		rotation.y += (deg_to_rad(turn_speed) * delta * turn_right)

func alert(check_los=true):
	if current_state != STATES.IDLE:
		return
	if check_los and !has_los_player():
		return
	set_state_chase()

func within_distance_of_player(distance: float):
	return global_transform.origin.distance_to(player.global_transform.origin) < attack_range








