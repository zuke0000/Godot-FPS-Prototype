extends Node3D

@onready var hit_effect = preload("res://effects/bullet_hit_effect.tscn") # if using once use load


@export var distance = 10000
var bodies_to_exclude = []
var damage = 1 # set by gun

func set_damage(_damage : int):
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude : Array):
	bodies_to_exclude = _bodies_to_exclude

func fire():
	var space_state = get_world_3d().get_direct_space_state() # changed in godot 4
	var our_position = global_transform.origin
	# raycast, also changed in Godot 4
	#var result = space_state.intersect_ray(
	#our_position - global_transform.basis.z * distance)
	#bodies_to_exclude, 1 + 2 + 4, true, true) # hit collision layers 2 and 4
	#var result = space_state.intersect_ray(our_position - global.transform.basis.z * distance)
	
	var direct_state = get_world_3d().direct_space_state
	var Parameters = PhysicsRayQueryParameters3D.create(our_position, our_position - global_transform.basis.z * distance)
	var result = direct_state.intersect_ray(Parameters)
	
	if result and result.collider.has_method("hurt"):
		result.collider.hurt(damage, result.normal)
	elif result: # if no hurt effect
		var hit_effect_instance = hit_effect.instantiate()
		get_tree().get_root().add_child(hit_effect_instance)
		hit_effect_instance.global_transform.origin = result.position # move effect to position
		
		if result.normal.angle_to(Vector3.UP) < 0.00005: # dont rotate if shooting floor
			return
		if result.normal.angle_to(Vector3.DOWN) < 0.00005: # shooting ceiling
			hit_effect_instance.rotate(Vector3.RIGHT, PI)
			return
		
		var y = result.normal
		var x = y.cross(Vector3.UP)
		var z = x.cross(y)
		
		hit_effect_instance.global_transform.basis = Basis(x,y,z) # orient correct  way
		
	
	
	
	
	
	
