extends Label


var countdown := [5,4,3,2,1]
var current_text = text
var can_restart = false

func _ready() -> void:
	hide()
	
	
func start_restart_timer():
	show()
	
	for number in countdown:
		text = "Press any key to restart in (" + str(number) + ')'
		await GlobalFunctions.wait_time(1)
	text = "Press any key to restart"
	can_restart = true

func _input(event: InputEvent) -> void:
	if event and can_restart:
		get_tree().reload_current_scene()
		await GlobalFunctions.wait_time(1)

