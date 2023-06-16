# NOTE: Not sure what the code below is from or how it got there. Seems to not be in use
extends CharacterBody3D


var explosion = preload("res://weapons/explosion.tscn")

var speed = 40
var impact_damage = 20 #direct hit damage
var exploded = false

func _ready():
	hide()

func set_bodies_to_exclude(bodies_to_exclude : Array):
	for body in bodies_to_exclude:
		add_collision_exception_with(body)

func _physics_process(delta):
	var collision : KinematicCollision3D = move_and_collide(
		-global_transform.basis.z * speed * delta)
	if collision:
		var collider = collision
		if collider.has_method("hurt"):
			collider.hurt(impact_damage, -global_transform.basis.z)
		explode()

func explode():
	if exploded:
		return
	exploded = true
	speed = 0
	$CollisionShape3D.disabled = true
	var explosion_instance = explosion.instantiate()
	get_tree().get_root().add_child(explosion_instance)
	explosion_instance.global_transform.origin = global_transform.origin
	explosion_instance.explode()
	$SmokeTrail.emitting = false
	$Graphics.hide()
	$DestroyAfterHitTimer.start() # despawn after some time














"""
extends CharacterBody3D


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
