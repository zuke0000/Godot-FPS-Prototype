extends Label

var ammo = 0
var health := 0.0
var max_health
var max_shield
var current_health
var current_shield

@onready var health_manager = $"../../HealthManager"
@onready var health_bar = $HealthBarHUD

@onready var blue_tint = Color(0.11, 0.62, 0.69, 1.0) # shield # full shield color
@onready var white_tint = Color(1.0, 1.0, 1.0, 1.0) # shield color as it goes down
@onready var red_tint = Color(0.63137, 0.00289, 0.14509, 1.0) # bar color if shield is down

func _ready():
	#health_manager.emit_max_health_and_shield.connect(set_max_values)
	health_manager.health_changed.connect(update_health)
	health_manager.shield_changed.connect(update_shield)
	health_manager.dead.connect(hide)
	health_bar.set_value_no_signal(100.0) # NOTE: might be a problem later 
	set_max_values()
	
func _process(delta):
	var display_prog = health_bar.value
	var max_value = health_bar.max_value
	var to_set = (current_health*0.5+current_shield) / (max_health * 0.5 +max_shield)*max_value
	if int(display_prog) != int(to_set):
		set_health_tween(to_set)
	if current_shield <= 0:
		pass
	if current_shield > 0.0:
		health_bar.tint_progress.a = 1.0
		health_bar.tint_progress = white_tint.lerp(blue_tint, current_shield/max_shield)
	else:
		set_bar_alpha()
		


func set_max_values():
	max_health = health_manager.max_health
	max_shield = health_manager.max_shield

func update_health(_current_health):
	current_health = _current_health
func update_shield(_current_shield):
	current_shield = _current_shield


func get_total_percent(_current_health, _current_shield):
	var total = max_health * 0.5 + max_shield
	return (_current_health*0.5 + _current_shield)/total * 100.0


func update_ammo(amount):
	ammo = amount
	update_display()
"""
func update_health(amount):
	health = amount
	update_display()
"""
func update_display():
	#$HealthHUD.text = 'Health: ' + str(health)
	if ammo < 0:
		$AmmoHUD.text = ''
		return
	$AmmoHUD.text = 'Ammo: ' + str(ammo)


var can_tween := true
func set_health_tween(_current_value):
	var wait_time := 0.01 # patchwork fix for the regen function spamming health by small amounts
	# TODO: instead of a timer this should use a queue or a different data object
	if can_tween:
		var tween = create_tween()
		tween.tween_property(
		health_bar, 
		"value", 
		_current_value,
		wait_time
		).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		can_tween = false
		await GlobalFunctions.wait_time(wait_time)
		can_tween = true

var value_to_set = 1.0
var tween
var one_or_zero := true
var flash_time := 0.5

func set_bar_alpha():
	if !tween:
		if one_or_zero:
			value_to_set = 1.0
		else:
			value_to_set = 0.0
		one_or_zero = !one_or_zero
		
		var color_to_set = red_tint
		color_to_set.a = value_to_set
		tween = create_tween()
		tween.tween_property(
		health_bar, 
		"tint_progress", 
		color_to_set,
		flash_time)
		await GlobalFunctions.wait_time(flash_time)
		tween = null
		

		
