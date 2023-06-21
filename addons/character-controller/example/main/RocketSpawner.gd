extends Node3D

@export var projectile = preload("res://weapons/rocket.tscn")
@export var impact_damage := 1
# TODO: set projectile speed with this variable
@export var speed := 10

var bodies_to_exclude = []
var damage = 1 # set by gun

func set_damage(_damage : int):
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude : Array):
	bodies_to_exclude = _bodies_to_exclude
	
func fire():
	var projectile_instance = projectile.instantiate()
	projectile_instance.set_bodies_to_exclude(bodies_to_exclude)
	get_tree().get_root().add_child(projectile_instance)
	projectile_instance.global_transform = global_transform
	projectile_instance.impact_damage = damage
