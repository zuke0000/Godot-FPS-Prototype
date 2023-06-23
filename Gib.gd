extends CharacterBody3D

@export var start_move_speed = 4
@export var grav = 35.0
@export var drag = 0.01
@export var velo_retained_on_bounce = 0.8 # 80%

var intitialized = false

func _ready():
	velocity = Vector3.ZERO
	init()

func init():
	intitialized = true
	velocity = -global_transform.basis.y * start_move_speed

func _physics_process(delta: float) -> void:
	if !intitialized:
		return
	velocity += -velocity * drag + Vector3.DOWN * grav * delta
	var collision = move_and_collide(velocity * delta)
	
	# reflection equation
	
	if collision:
		var d = velocity
		var n = collision.get_normal()
		var r = d - 2 * d.dot(n) * n
		velocity = r * velo_retained_on_bounce
