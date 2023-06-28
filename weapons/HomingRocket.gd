# NOTE: Not sure what the code below is from or how it got there. Seems to not be in use
extends CharacterBody3D


var explosion = preload("res://weapons/explosion.tscn")
@onready var face_target_y = $FaceTargetY
@onready var face_target_x = $FaceTargetY/FaceTargetX

@export var impact_damage = 20 #direct hit damage
@export var explosion_damage = 40
@export var speed := 40
@export var turn_speed := 30.0
@export var turn_threshold := 30.0

var exploded = false
var target

func setup():
	target = get_tree().get_first_node_in_group("player")
	face_target_y.turn_speed = turn_speed
	face_target_x.turn_speed = turn_speed
	face_target_y.turn_threshold = turn_threshold
	face_target_x.turn_threshold = turn_threshold		

func setup_instance(instance):
	instance.damage = explosion_damage
	
	
func _ready():
	setup()
	hide()

func set_bodies_to_exclude(bodies_to_exclude : Array):
	for body in bodies_to_exclude:
		add_collision_exception_with(body)
	
	
func _physics_process(delta):
	
	# bandaid fix to prevent crashes when reloading scene
	target = get_tree().get_first_node_in_group("player") 
	var target_position = target.global_transform.origin
	face_target_y.face_point(target_position, delta)
	face_target_x.face_point(target_position, delta)
	
	var move_direction = -$FaceTargetY/FaceTargetX/DirectionReference.global_transform.basis.z
	var collision : KinematicCollision3D = move_and_collide(move_direction * speed * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("hurt"):
			collider.hurt(impact_damage, -global_transform.basis.z, position)
		explode()

func explode():
	if exploded:
		return
	exploded = true
	speed = 0
	$CollisionShape3D.disabled = true
	var explosion_instance = explosion.instantiate()
	setup_instance(explosion_instance)
	get_tree().get_root().add_child(explosion_instance)
	explosion_instance.global_transform.origin = global_transform.origin
	explosion_instance.explode()
	$SmokeTrail.emitting = false
	$Graphics.hide()
	$DestroyAfterHitTimer.start() # despawn after some time



