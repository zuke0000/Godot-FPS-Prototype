extends CharacterBody3D

enum STATES {IDLE, CHASE, ATTACK, DEAD}
var current_state = STATES.IDLE
@onready var animation_player = $Graphics/AnimationPlayer
@onready var health_manager = $HealthManager
var player = null
@export var sight_angle = 45 # enemy can see 45 degrees left and right to spot the player
signal monster_hurt # not in use. Perhaps remove?


func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	var bone_attachments = $Graphics/Armature/Skeleton3D.get_children()
	for bone_attachment in bone_attachments:
		for child in bone_attachment.get_children():
			if child is HitBox:
				child.hitbox_hurt.connect(hurt)
	set_state_idle() # idle when spawning
	health_manager.dead.connect(set_state_dead)
	
func hurt(damage: int, dir: Vector3):
	if current_state == STATES.IDLE:
		set_state_chase()
	health_manager.hurt(damage, dir)


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
	print('chasing')
	current_state = STATES.CHASE

func set_state_attack():
	current_state = STATES.ATTACK

func set_state_dead():
	current_state = STATES.DEAD
	animation_player.play("die")

func process_state_idle(delta):
	if can_see_player():
		set_state_chase()
	
func process_state_chase(delta):
	pass
func process_state_attack(delta):
	pass
func process_state_dead(delta):
	pass

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
		
func alert(check_los=true):
	if current_state != STATES.IDLE:
		return
	if check_los and !has_los_player():
		return
	set_state_chase()

"""
NOTE: For some reason this code came when creating the script.
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
"""
