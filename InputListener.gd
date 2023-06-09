extends Node

var show_debug_stats = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: put in signals here if performance is bad. 
	_quit_listener()
	_reset_listener()
	_debug_stats_listener()


func _quit_listener():
	if Input.is_action_pressed("close_program"):
		get_tree().quit()

func _reset_listener():
	if Input.is_action_pressed("restart_program"):
		get_tree().reload_current_scene()
		
func _debug_stats_listener():
	if Input.is_action_just_pressed("debug_stats"):
		global.show_debug_stats()

func _on_global_variables_debug_stats(value):
	pass # Replace with function body.
