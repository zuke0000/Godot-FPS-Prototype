# NOTE: Not sure what the code below is from or how it got there. Seems to not be in use
extends CharacterBody3D


var explosion = preload("res://weapons/explosion.tscn")

var speed = 20
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
		$SmokeParticles.emitting = true
		speed = 0
		$Graphics.hide()
		$CollisionShape3D.disabled = true
		#explode()

"""
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



