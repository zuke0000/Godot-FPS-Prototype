extends Node3D

@onready var anim_player = $AnimationPlayer
@onready var bullet_emitters_base : Node3D = $BulletEmitters
@onready var bullet_emitters = $BulletEmitters.get_children()

@export var automatic = false

var fire_point = Node3D
var bodies_to_exclude : Array = []

@export var damage := 5
@export var ammo = 30

@export var attack_rate = 0.2
@export var spread := 0.01
@export var bullets_per_shot := 1
@export var is_hitscan = true

# TODO: like in destiny have damage dropoff. Dropoff linearly after distance excedes dropoff distance
# Damage dropoff system
@export var damage_dropoff_distance := 30 
@export var damage_minimum = 2

# TODO: Reload system
@export var reload_time = 1
@export var shield_cost = 0

# TODO: aim assist system
@export var aim_assist_degrees := 1 # angles of error allowed for bullets to bend toward target
@export var aim_assist_magnetism := 0.5 # percentage of error the bullet will bend towards target
# For example with these values a player could shoot off by 1 degree but the bullet will bend
# 0.5 * 1 = 0.5 degrees towards the closest hitbox


var attack_timer : Timer
var can_attack = true

signal fired
signal out_of_ammo


var hitscan_node = preload("res://effects/hitscan_bullet_emitter.tscn")

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	#attack_timer.connect("timeout", $".","finish_attack")
	attack_timer.timeout.connect(finish_attack) # 
	attack_timer.one_shot = true
	add_child(attack_timer)
	
	# create bullet emitters
	for i in bullets_per_shot:
		var instance = hitscan_node.instantiate()
		#for bullet_emitter in bullet_emitters:
		# NOTE: set variables here was taken from init. This seems to be the right spot
		instance.set_damage(damage)
		instance.set_bodies_to_exclude(bodies_to_exclude)
		bullet_emitters_base.add_child(instance)
	
	
func init(_fire_point: Node3D, _bodies_to_exclude: Array):
	fire_point = _fire_point
	bodies_to_exclude = _bodies_to_exclude
	
		
func attack(attack_input_just_pressed: bool, attack_input_held: bool):
	if !can_attack:
		return
	if automatic and !attack_input_held:
		return
	if !automatic and !attack_input_just_pressed:
		return
	if ammo == 0:
		if attack_input_just_pressed:
			emit_signal("out_of_ammo")
		return
		
	if ammo > 0 and can_attack:
		ammo -= 1
	
	var start_transform = bullet_emitters_base.global_transform
	bullet_emitters_base.global_transform = fire_point.global_transform
	
	bullet_emitters = bullet_emitters_base.get_children()
	var original_rotation
	
	if (is_hitscan):
		for bullet_emitter in bullet_emitters:
			if len(bullet_emitters) > 1:
				original_rotation = bullet_emitter.rotation
				bullet_emitter.rotation.x += randf_range(-spread,spread)
				bullet_emitter.rotation.y += randf_range(-spread,spread)
			bullet_emitter.fire()
			bullet_emitter.rotation = original_rotation if (original_rotation) else bullet_emitter.rotation
	bullet_emitters_base.global_transform = start_transform
	
	anim_player.stop()
	anim_player.play("attack")
	emit_signal("fired")
	can_attack = false
	attack_timer.start()
	
func finish_attack():
	can_attack = true

func set_active():
	show()
	$Graphics/Crosshair.show()
	
func set_inactive():
	anim_player.play("idle")
	hide()
	$Graphics/Crosshair.hide()
	

func is_idle():
	pass
