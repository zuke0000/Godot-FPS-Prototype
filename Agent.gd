extends Node3D

@onready var vision_manager = $FaceTargetY/VisionManager
@onready var face_target_y = $FaceTargetY
@onready var face_target_x = $FaceTargetY/FaceTargetX


var target : CharacterBody3D

func _ready():
	target = get_tree().get_first_node_in_group("player")
	
func _process(delta):
	
	var target_point = target.global_transform.origin
	if vision_manager.in_vision_cone(target_point) and vision_manager.has_los(target_point):
		face_target_y.face_point(target_point, delta)
		face_target_x.face_point(target_point, delta)
	
	if face_target_y.is_facing_target(target_point) and face_target_x.is_facing_target(target_point):
		show_red()
	else:
		show_yellow()
	
func show_red():
	$FaceTargetY/Graphics/Red.show()
	$FaceTargetY/Graphics/Yellow.hide()

func show_yellow():
	$FaceTargetY/Graphics/Red.hide()
	$FaceTargetY/Graphics/Yellow.show()
