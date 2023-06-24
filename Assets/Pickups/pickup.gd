extends Area3D

class_name Pickup

enum PICKUP_TYPE 
{MACHINE_GUN, MACHINE_GUN_AMMO,
ROCKET_LAUNCHER, ROCKET, 
SHOTGUN, SHOTGUN_AMMO, 
HEALTH}

@export var pickup_type:PICKUP_TYPE
@export var ammo := 10
@onready var children = $Graphics.get_children()

@onready var pickup_type_child = {
	'MACHINE_GUN' : children[0],
	'MACHINE_GUN_AMMO' : children[1],
	'ROCKET_LAUNCHER': children[2],
	'ROCKET' : children[3],
	'SHOTGUN' : children[4],
	'SHOTGUN_AMMO' : children[5],
	'HEALTH' : children[6],
}

func _ready():
	for child in children:
		child.hide()
	var chosen_pickup = pickup_type_child.values()[pickup_type]
	chosen_pickup.show()
	$AnimationPlayer.play('spin')
	
