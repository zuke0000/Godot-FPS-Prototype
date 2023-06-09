extends Node

const fps_dictionary = {
	0:30,
	1:60,
	2:120,
	3:240,
	4:480,
}
var frame_rates = [30, 60, 120, 240, 480]
var default_frame_rate = frame_rates[2]

var debug_stats = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_frame_rate(default_frame_rate)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_frame_rate(limit):
	Engine.max_fps = limit if limit else 60
	#pass

func show_debug_stats():
	debug_stats = !debug_stats
	
