extends Node3D

@export var projectile = preload("res://weapons/rocket.tscn")
@export var impact_damage := 0.0
@onready var should_override_impact_damage = impact_damage > 0
@export var damage := 30.0
@export var speed := 10.0
@export var gravity := 0.0
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
	instance_setter_functions(projectile_instance)
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

func instance_setter_functions(instance):
	instance.set_bodies_to_exclude(bodies_to_exclude)
	if should_override_impact_damage and instance.has_method("set_impact_damage"):
		instance.set_impact_damage(impact_damage)
	if instance.has_method("set_speed"):
		instance.set_speed(speed)
	if instance.has_method("set_explosion_damage"):
		instance.set_explosion_damage(damage)
	if instance.has_method("set_gravity"):
		instance.set_gravity(gravity)

# Returns position to aim at
func get_aim_prediction_point_unused():
	
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


const NUM_OF_ITERATIONS = 5
func get_aim_prediction_point():
	
	var projectile_start_pos = global_transform.origin
	var target_start_pos = target.global_transform.origin
	var target_velocity = target.get_velocity()
	var target_future_pos = target_start_pos
	var final_angle = 0.0
	for i in range(NUM_OF_ITERATIONS):
		var dist_to_target = projectile_start_pos.distance_to(target_future_pos)
		var target_height = target_future_pos.y - projectile_start_pos.y
		var angle = get_angle_to_target_point(dist_to_target, target_height, speed, gravity)
		if angle == null:
			return target_start_pos
		
		var vec_to_target = projectile_start_pos - target_future_pos
		vec_to_target.y = 0.0
		var h_dist_to_target = vec_to_target.length()
		var time_in_air = h_dist_to_target / (cos(angle) * speed)
		
		target_future_pos = target_start_pos + target_velocity * time_in_air
		final_angle = angle
	
	var n = target_future_pos - projectile_start_pos
	var y_rotation = atan2(-n.x, -n.z)
	var predictive_dir = Vector3.FORWARD.rotated(Vector3.RIGHT, final_angle).rotated(Vector3.UP, y_rotation)
	return projectile_start_pos + predictive_dir * 20.0

func get_angle_to_target_point(d, y, S, G):
	if G == 0:
		G = 0.001
	# the equation: atan(s^2 +- sqrt((s^4 - G(Gx^2 + 2S^2y))) / Gx)
	var root = S * S * S * S - G * (G * d * d + 2.0 * y * S * S)
	if root < 0.0:
		print('out of range')
		return null
	
	root = sqrt(root)
	var sub = G * d
	var s_sq = S * S
	var angle1 = atan((s_sq + root) / sub)
	var angle2 = atan((s_sq - root) / sub)
	
	return min(angle1,angle2)
	#return max(angle1,angle2)
	
