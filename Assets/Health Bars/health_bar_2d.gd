extends Node3D

var max_health
var max_shield
var current_health
@onready var health_manager = $"../HealthManager"
@onready var bar = $Viewport/HealthBar
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#health_manager.emit_max_health_and_shield.connect(set_max_values)
	health_manager.health_changed.connect(update_health)
	health_manager.dead.connect(hide)
	bar.set_value_no_signal(100.0) # TODO: might be a problem later 
	set_max_values()
	
	
func set_max_values():
	max_health = health_manager.max_health
	max_shield = health_manager.max_shield

func update_health(_current_health):
	current_health = _current_health
	bar.set_value_no_signal(get_health_percent(current_health))

func get_health_percent(_current_health):
	print(_current_health/max_health)
	return (_current_health/max_health) * 100.0
	



