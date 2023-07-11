extends Node2D

onready var hurtbox = $KinematicBody2D/HurtBox
onready var health = $Health
onready var healthbar = $KinematicBody2D/Sprite/HealthBar

func _ready():
	health.connect("changed", healthbar, "set_value")
	health.connect("max_changed", healthbar, "set_max")
	health.initialize()


func _on_HurtBox_body_entered(body):
	health.current -= body.damage
	hurtbox.set_deferred("monitoring", false)
	hurtbox.get_node("RecoverTimer").start()
	healthbar.show()


func _on_RecoverTimer_timeout():
	hurtbox.set_deferred("monitoring", true)


func _on_Health_depleted():
	queue_free()
