extends FPSController3D
class_name Player

## Example script that extends [CharacterController3D] through 
## [FPSController3D].
## 
## This is just an example, and should be used as a basis for creating your 
## own version using the controller's [b]move()[/b] function.
## 
## This player contains the inputs that will be used in the function 
## [b]move()[/b] in [b]_physics_process()[/b].
## The input process only happens when mouse is in capture mode.
## This script also adds submerged and emerged signals to change the 
## [Environment] when we are in the water.

@export var input_back_action_name := "move_backward"
@export var input_forward_action_name := "move_forward"
@export var input_left_action_name := "move_left"
@export var input_right_action_name := "move_right"
@export var input_sprint_action_name := "move_sprint"
@export var input_jump_action_name := "move_jump"
@export var input_crouch_action_name := "move_crouch"
@export var input_fly_mode_action_name := "move_fly_mode"

@export var underwater_env: Environment

var frozen = false
var dead = false
@onready var health_manager = $HealthManager
@onready var weapon_manager = $Head/Camera/WeaponManager
@onready var pickup_manager = $PickupManager
var hotkeys = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3,
	KEY_5: 4,
	
}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	setup()
	emerged.connect(_on_controller_emerged.bind())
	submerged.connect(_on_controller_subemerged.bind())
	
	#health_manager.connect("dead", self, "kill")
	
	health_manager.dead.connect(kill)
	weapon_manager.init($Head/Camera/FirePoint, [self])
	health_manager.health_changed.connect(pickup_manager.update_player_health)
	pickup_manager.got_pickup.connect(weapon_manager.get_pickup)
	pickup_manager.got_pickup.connect(health_manager.get_pickup)
	health_manager.init()

# weapon inputs
func _process(delta):
	if frozen:
		return
	
	if Input.is_action_just_pressed("WeaponUp"):
		weapon_manager.switch_to_next_weapon()
	if Input.is_action_just_pressed("WeaponDown"):
		weapon_manager.switch_to_last_weapon()
		
	
	if Input.is_action_just_pressed("Shoot") or Input.is_action_pressed("Shoot"):
		weapon_manager.attack(Input.is_action_just_pressed("Shoot"),Input.is_action_pressed("Shoot"))
	
	
	# NOTE: Everything below was taken from physics_process
	var is_valid_input := Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	
	if is_valid_input:
		if Input.is_action_just_pressed(input_fly_mode_action_name):
			fly_ability.set_active(not fly_ability.is_actived())
		var input_axis = Input.get_vector(input_back_action_name, input_forward_action_name, input_left_action_name, input_right_action_name)
		var input_jump = Input.is_action_just_pressed(input_jump_action_name)
		var input_crouch = Input.is_action_pressed(input_crouch_action_name)
		#var input_sprint = Input.is_action_pressed(input_sprint_action_name)
		var input_sprint = Input.is_action_just_pressed(input_sprint_action_name)
		var input_swim_down = Input.is_action_pressed(input_crouch_action_name)
		var input_swim_up = Input.is_action_pressed(input_jump_action_name)
		move(delta, input_axis, input_jump, input_crouch, input_sprint, input_swim_down, input_swim_up)
# NOTE: Apparently inputs are usually put in _process(delta) instead of physics. 
# Keep an eye on this
# TODO: perhaps input buffer will work with _physics instead of _physics_process?
func _physics_process(delta):
	
	
	
	
	if dead:
		return
	
	var is_valid_input := Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	
	if !is_valid_input:
		# NOTE: It is important to always call move() even if we have no inputs 
		## to process, as we still need to calculate gravity and collisions.
		
		move(delta)


func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if frozen:
		return
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_head(event.relative)
		
	# NOTE: fix for inputs in _process not picking up scrollwheel
	# Not required in Godot 4.1 
	if event.is_action_pressed("wheel_up"):
		pass
		#weapon_manager.switch_to_next_weapon()
	if event.is_action_pressed("wheel_down"):
		pass
		#weapon_manager.switch_to_last_weapon()
	
		
func _on_controller_emerged():
	camera.environment = null


func _on_controller_subemerged():
	camera.environment = underwater_env
	
func freeze():
	frozen = true

func unfreeze():
	frozen = false
	
## Health stuff
func hurt(damage, dir, pos=Vector3.ZERO):
	print('hurt from player called')
	health_manager.hurt(damage, dir)

func heal(amount):
	health_manager.heal(amount)
	
func kill():
	dead = true
	freeze()
