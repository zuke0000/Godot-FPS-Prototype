extends KinematicBody2D

const SNAP_LENGTH = 64
const SNAP_DIRECTION = Vector2.DOWN
const FLOOR_NORMAL = Vector2.UP

export(float) var speed = 400.0
export(float) var gravity_strength = 3000.0

var direction = Vector2.LEFT
onready var velocity = direction * speed

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH

func _physics_process(delta):
	velocity.y += gravity_strength * delta
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, deg2rad(46)).y
	if is_on_wall():
		direction *= -1
		velocity.x = direction.x * speed
