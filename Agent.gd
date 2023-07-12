extends CharacterBody3D

enum STATES {IDLE, CHASE, ATTACK, DEAD}
var current_state = STATES.IDLE

@onready var vision_manager = $FaceTargetY/VisionManager
@onready var face_target_y = $FaceTargetY
@onready var face_target_x = $FaceTargetY/FaceTargetX
@onready var character_mover = $CharacterMover
@onready var character_navigation = $CharacterNavigation
@onready var projectile_spawner = $FaceTargetY/FaceTargetX/ProjectileSpawner
@onready var health_manager = $HealthManager
var target : CharacterBody3D

@export_category("Attacking")
@export var attack_range = 2.0 # range of 2 meters
@export var attack_rate = 1
@export var attack_speed_multiplier := 1.25

@export_category("Health")
@export var health := 100.0
@export var shield := 50.0

@export_category("Movement")
@export var move_speed := 10.0
@export var sight_angle = 45 # enemy can see 45 degrees left and right to spot the player
@export var turn_speed := 360 #360 degrees per second


var attack_timer : Timer
var can_attack = true
var frozen = false

func _ready():
	target = get_tree().get_first_node_in_group("player")
	character_mover.init(self)
	projectile_spawner.set_target(target)
	
	#var bone_attachments = $Graphics/Armature/Skeleton3D.get_children()
	#for bone_attachment in bone_attachments:
	#	for child in bone_attachment.get_children():
	#		if child is HitBox:
	#			child.hitbox_hurt.connect(hurt)
	#set_state_idle() # idle when spawning
	#health_manager.dead.connect(set_state_dead)
	
	$HitBox.hitbox_hurt.connect(hurt)
	health_manager.init(health, shield)
	health_manager.dead.connect(set_frozen)
	health_manager.dead.connect(character_mover.freeze)
	
func _process(delta):
	if frozen:
		return
	var target_point = target.global_transform.origin
	#face_target_y.face_point(target_point, delta)
	#face_target_x.face_point(target_point, delta)
	
	
	
	if vision_manager.in_vision_cone(target_point) and vision_manager.has_los(target_point):
		character_navigation.follow_target(delta, target)
		show_red()
		var point_to_fire = projectile_spawner.get_aim_prediction_point()
		face_target_y.face_point(point_to_fire, delta)
		face_target_x.face_point(point_to_fire, delta)
		projectile_spawner.fire_with_cooldown()
		
	else:
		show_yellow()
		character_navigation.no_target(delta)
		
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

func hurt(damage: int, dir: Vector3, pos: Vector3):
	health_manager.hurt(damage, dir, pos)

func set_frozen():
	frozen = true

