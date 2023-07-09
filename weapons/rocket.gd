# NOTE: Not sure what the code below is from or how it got there. Seems to not be in use
extends CharacterBody3D


var explosion = preload("res://weapons/explosion.tscn")

var speed = 40
var explosion_damage = 30
var impact_damage = 10 #direct hit damage
var exploded = false
var gravity := 0.0

func set_speed(_speed):
	speed = _speed
func set_impact_damage(_impact_damage):
	impact_damage = _impact_damage
func set_explosion_damage(_explosion_damage):
	explosion_damage = _explosion_damage
func set_gravity(_gravity):
	gravity = _gravity

func _ready():
	hide()

func set_bodies_to_exclude(bodies_to_exclude : Array):
	for body in bodies_to_exclude:
		add_collision_exception_with(body)

func _physics_process(delta):
	velocity.y -= gravity * delta
	
	var collision : KinematicCollision3D = move_and_collide(
		-global_transform.basis.z * speed * delta)
	move_and_slide()
	if is_on_floor():
		explode()
	
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
	if explosion_instance.has_method("set_explosion_damage"):
		explosion_instance.set_explosion_damage(explosion_damage)
		
	get_tree().get_root().add_child(explosion_instance)
	explosion_instance.global_transform.origin = global_transform.origin
	explosion_instance.explode()
	$SmokeTrail.emitting = false
	$Graphics.hide()
	$DestroyAfterHitTimer.start() # despawn after some time



