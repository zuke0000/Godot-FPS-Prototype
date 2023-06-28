extends Node3D


@export var vision_cone_arc := 60.0
@export var distance := 100

func in_vision_cone(point: Vector3):
	var forward = -global_transform.basis.z
	var our_position = global_transform.origin
	var direction_to_point = point - our_position
	return rad_to_deg(direction_to_point.angle_to(forward)) <= vision_cone_arc/2.0

# line of sight (los) check 
# NOTE: If expensive and causes performance issues, check every other frame
func has_los(point : Vector3):
	
	var our_position = global_transform.origin
	
	var direct_state = get_world_3d().direct_space_state
	var Parameters = PhysicsRayQueryParameters3D.new()#(our_position, our_position - global_transform.basis.z * distance, (1 + 4), bodies_to_exclude)
	Parameters.from = our_position
	#Parameters.to = our_position - global_transform.basis.z * distance
	Parameters.to = point
	#Parameters.exclude = bodies_to_exclude
	Parameters.collision_mask = 1 # Layers to collide with. 1: Environment 
	Parameters.hit_back_faces = true #
	Parameters.collide_with_areas = true # This was required for working with enemy hitboxes
	#Parameters.hit_from_inside = true
	
	var result = direct_state.intersect_ray(Parameters)
	if result:
		return false
	return true
