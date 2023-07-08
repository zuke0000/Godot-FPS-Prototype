extends Node3D

@export var projectile = preload("res://weapons/rocket.tscn")
@export var impact_damage := 0.0
@onready var should_override_impact_damage = impact_damage > 0
@export var damage := 30.0
# TODO: set projectile speed with this variable
@export var speed := 10.0
@export var cooldown := 1.0
@export var predict_target := false
var can_fire := true
var target
var bodies_to_exclude = []

func set_damage(_damage : int):
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude : Array):
	bodies_to_exclude = _bodies_to_exclude
	
func fire():
	var projectile_instance = projectile.instantiate()
	projectile_instance.set_bodies_to_exclude(bodies_to_exclude)
	if should_override_impact_damage and projectile_instance.has_method("set_impact_damage"):
		projectile_instance.set_impact_damage(impact_damage)
	if projectile_instance.has_method("set_speed"):
		projectile_instance.set_speed(speed)
	if projectile_instance.has_method("set_explosion_damage"):
		projectile_instance.set_explosion_damage(damage)
	get_tree().get_root().add_child(projectile_instance)
	projectile_instance.global_transform = global_transform

func fire_with_cooldown():
	if can_fire:
		fire()
		wait_fire_cooldown()
	return

func wait_fire_cooldown():
	can_fire = false
	await GlobalFunctions.wait_time(cooldown)
	can_fire = true

func set_target(_target):
	target = _target

# Returns position to aim at
func get_aim_prediction_point():
	
	# algebraic vector math
	var Pti = target.global_transform.origin # target pos
	var Pbi = global_transform.origin # bullet pos
	var D = Pti.distance_to(Pbi)
	var Vt = target.velocity # might need get_velocity func from target
	var St = Vt.length()
	var Sb = speed
	var cos_theta = Pti.direction_to(Pbi).dot(Vt.normalized())
	
	var q_root = sqrt(2*D*St*cos_theta + 4*(Sb*Sb - St*St) * D*D)
	var q_sub = (2*(Sb*Sb - St*St))
	var q_left = -2*D*St*cos_theta
	var t1 = (q_left + q_root) / q_sub
	var t2 = (q_left - q_root) / q_sub
	
	var t = min(t1,t2)
	if t<0:
		t = max(t1,t2)
	if t<0:
		print('impossible')
		return target.global_transform.origin
		
	return Vt * t + Pti
