extends Area3D


@export var damage = 40

func explode():
	$GPUParticles3D.emitting = true
	$GPUParticles3D2.emitting = true
	$GPUParticles3D3.emitting = true
	var query = PhysicsShapeQueryParameters3D.new()
	query.set_transform(global_transform)
	query.set_shape($CollisionShape3D.shape)
	query.collision_mask = collision_mask
	var space_state = get_world_3d().get_direct_space_state()
	
	var results = space_state.intersect_shape(query)
	
	for data in results:
		if data.collider.has_method("hurt"):
			data.collider.hurt(damage, global_transform.origin.direction_to(data.collider.global_transform.origin), data.collider.position)
		
			
