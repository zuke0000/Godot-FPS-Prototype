extends Timer

var time_elapsed := 0.0
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta



