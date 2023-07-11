extends Node2D

onready var hurtbox = $KinematicBody2D/HurtBox
onready var recover_timer = $KinematicBody2D/HurtBox/RecoverTimer
onready var health = $Health

func _on_HurtBox_body_entered(body):
	health.current -= body.damage
	hurtbox.set_deferred("monitoring", false)
	recover_timer.start()


func _on_RecoverTimer_timeout():
	hurtbox.set_deferred("monitoring", true)


func _on_Health_depleted():
	queue_free()
