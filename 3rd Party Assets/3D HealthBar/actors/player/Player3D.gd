extends Spatial

onready var healthbar = $HealthBar3D/Viewport/HealthBar
onready var health = $Health

func _ready():
	health.connect("changed", healthbar, "set_value")
	health.connect("max_changed", healthbar, "set_max")
	health.initialize()
