extends CharacterBody3D

@onready var vision_manager = $FaceTargetY/VisionManager
@onready var face_target_y = $FaceTargetY
@onready var face_target_x = $FaceTargetY/FaceTargetX
@onready var character_mover = $CharacterMover
@onready var character_navigation = $CharacterNavigation
@onready var projectile_spawner = $FaceTargetY/FaceTargetX/ProjectileSpawner
var target : CharacterBody3D


func _ready():
	target = get_tree().get_first_node_in_group("player")
	character_mover.init(self)
	projectile_spawner.set_target(target)


func _process(delta):
	var target_point = target.global_transform.origin
	#face_target_y.face_point(target_point, delta)
	#face_target_x.face_point(target_point, delta)
	
		
	#print('shoot at: ', point_to_fire)
	projectile_spawner.fire_with_cooldown()
	
	if vision_manager.in_vision_cone(target_point) and vision_manager.has_los(target_point):
		show_red()
		var point_to_fire = projectile_spawner.get_aim_prediction_point()
		face_target_y.face_point(point_to_fire, delta)
		face_target_x.face_point(point_to_fire, delta)
		#character_navigation.follow_target(delta, target)
	else:
		show_yellow()
		#character_navigation.no_target(delta)
		
	if face_target_y.is_facing_target(target_point) and face_target_x.is_facing_target(target_point) and vision_manager.has_los(target_point):
		show_red()
		#character_navigation.follow_target(delta, target)
		#var point_to_fire = projectile_spawner.get_aim_prediction_point()
		
		
	else:
		pass
		#show_yellow()
		#character_navigation.no_target(delta)
		
	
func show_red():
	$FaceTargetY/Graphics/Red.show()
	$FaceTargetY/Graphics/Yellow.hide()

func show_yellow():
	$FaceTargetY/Graphics/Red.hide()
	$FaceTargetY/Graphics/Yellow.show()
