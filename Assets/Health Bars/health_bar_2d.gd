extends Node3D

var max_health
var max_shield
var current_health
var current_shield
@onready var health_manager = $"../HealthManager"
@onready var health_bar = $Viewport/HealthBar
@onready var shield_bar = $Viewport/HealthBar/ShieldBar
@onready var damage_bar = $Viewport/HealthBar/DamageBar
@export var damage_bar_delay := 0.5

	
# Called when the node enters the scene tree for the first time.
func _ready():
	#health_manager.emit_max_health_and_shield.connect(set_max_values)
	health_manager.health_changed.connect(update_health)
	health_manager.shield_changed.connect(update_shield)
	health_manager.dead.connect(hide)
	health_bar.set_value_no_signal(100.0)
	set_max_values()

func _process(delta):
	if current_health:
		var health_percent = get_health_percent(current_health)
		if health_bar.value != health_percent:
			set_bar_tween(health_bar, health_percent, 0.25)
			set_bar_tween(damage_bar, health_percent, 0.25, damage_bar_delay)
	if current_shield:
		var shield_percent = get_shield_percent(current_shield)
		if shield_bar.value != shield_percent:
			set_bar_tween(shield_bar, shield_percent, 0.25)
	else:
		set_bar_tween(shield_bar, 0.0, 0.25)
	
func set_max_values():
	max_health = health_manager.max_health
	max_shield = health_manager.max_shield

func update_health(_current_health):
	current_health = _current_health
	#health_bar.set_value_no_signal(get_health_percent(current_health))
func update_shield(_current_shield):
	current_shield = _current_shield

func get_health_percent(_current_health):
	return (_current_health/max_health) * 100.0
func get_shield_percent(_current_shield):
	return (_current_shield / max_shield) * 100.0

func set_bar_tween(_bar, _new_value, _tween_time, _delay = 0.0):
	if _delay > 0.0:
		await GlobalFunctions.wait_time(_delay)
	var tween = create_tween()
	tween.tween_property(
	_bar, 
	"value", 
	_new_value,
	_tween_time
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)


