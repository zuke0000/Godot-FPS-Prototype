extends Node3D


var rocket = preload("res://weapons/rocket.tscn")

var bodies_to_exclude = []
var damage = 1 # set by gun

func set_damage(_damage : int):
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude : Array):
	bodies_to_exclude = _bodies_to_exclude
	
func fire():
	var rocket_instance = rocket.instantiate()
	rocket_instance.set_bodies_to_exclude(bodies_to_exclude)
	get_tree().get_root().add_child(rocket_instance)
	rocket_instance.global_transform = global_transform
	rocket_instance.impact_damage = damage
