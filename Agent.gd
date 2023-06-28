extends Node3D

@onready var vision_manager = $VisionManager

var target : CharacterBody3D

func _ready():
	target = get_tree().get_first_node_in_group("player")
	
func _process(delta):
	var target_point = target.global_transform.origin + Vector3.UP
	if vision_manager.in_vision_cone(target_point) and vision_manager.has_los(target_point):
		$Graphics/Red.hide()
		$Graphics/Yellow.show()
	else:
		$Graphics/Red.show()
		$Graphics/Yellow.hide()
	
