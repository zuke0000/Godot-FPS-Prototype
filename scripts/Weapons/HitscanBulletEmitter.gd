extends Node3D

@onready var hit_effect = preload("res://effects/bullet_hit_effect.tscn") # if using once use load
@onready var trace_effect = preload("res://effects/bullet_trace_effect.tscn")

@export var distance = 10000
var bodies_to_exclude = []
var damage = 1 # set by gun

func set_damage(_damage : int):
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude : Array):
	bodies_to_exclude = _bodies_to_exclude

# NOTE: this function is ugly. 
func fire():
	var space_state = get_world_3d().get_direct_space_state() # changed in godot 4
	var our_position = global_transform.origin
	var end_position = our_position - global_transform.basis.z * distance
	var our_trace_position = our_position - global_transform.basis.z * 1
	create_trace_instance(our_trace_position, end_position)
	# raycast, also changed in Godot 4
	#var result = space_state.intersect_ray(
	#our_position - global_transform.basis.z * distance)
	#bodies_to_exclude, 1 + 2 + 4, true, true) # hit collision layers 2 and 4
	#var result = space_state.intersect_ray(our_position - global.transform.basis.z * distance)
	
	var direct_state = get_world_3d().direct_space_state
	var Parameters = PhysicsRayQueryParameters3D.new()#(our_position, our_position - global_transform.basis.z * distance, (1 + 4), bodies_to_exclude)
	Parameters.from = our_position
	Parameters.to = end_position
	Parameters.exclude = bodies_to_exclude
	Parameters.collision_mask = 1 + 4 # Layers to collide with. 1: Environment and 4: hitboxes
	Parameters.hit_back_faces = false #
	Parameters.collide_with_areas = true # This was required for working with enemy hitboxes
	#Parameters.hit_from_inside = true
	
	var result = direct_state.intersect_ray(Parameters)
	
	if result and result.collider.has_method("hurt"):
		result.collider.hurt(damage, result.normal, result.position)
	elif result: # if no hurt effect, create a bullet hole
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
		
func create_trace_instance(from,to):
	var trace_effect_instance = trace_effect.instantiate()
	trace_effect_instance.init(from,to)
	get_tree().get_root().add_child(trace_effect_instance)
	return
	
	
	
	
