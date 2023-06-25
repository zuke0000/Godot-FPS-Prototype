extends Node3D

func _ready():
	hide()
	
func enable_gibs():
	show()
	for child in get_children():
		if child.has_method('init'):
			GlobalFunctions.random_rotate(child)
			child.start_move_speed = randf_range(15, 25)
			child.init()
		if "emitting" in child:
			child.emitting = true
	
	GlobalFunctions.despawn_time(self, 7)
