extends Area3D


var bodies_to_exclude = []
var damage = 1

func set_damage(_damage : int):
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude : Array):
	print('bodies to exclude set to: ', _bodies_to_exclude)
	bodies_to_exclude = _bodies_to_exclude
	
func fire():
	for body in get_overlapping_bodies():
		if body.has_method("hurt") and (body not in bodies_to_exclude):
			body.hurt(damage, global_transform.origin.direction_to(body.global_transform.origin), body.position)
			
		
