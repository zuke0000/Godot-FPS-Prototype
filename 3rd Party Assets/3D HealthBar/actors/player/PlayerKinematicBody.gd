extends KinematicBody2D

const SNAP_LENGTH = 64
const SNAP_DIRECTION = Vector2.DOWN
const FLOOR_NORMAL = Vector2.UP

export(float) var speed = 400.0
export(float) var jump_strength = 1200.0
export(float) var gravity_strength = 3000.0

var direction = Vector2.ZERO
var velocity = direction * speed

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH

func _physics_process(delta):
	velocity.y += gravity_strength * delta
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, deg2rad(46)).y
	if is_on_floor() and not snap_vector == SNAP_DIRECTION * SNAP_LENGTH:
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH


func _unhandled_input(event):
	if event.is_action("move_left") or event.is_action("move_right"):
		direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		velocity.x = direction.x * speed
	elif event.is_action("jump"):
		snap_vector = Vector2.ZERO
		if is_on_floor():
			velocity.y = -jump_strength
		elif velocity.y < 0.0:
			velocity.y = 0.0
