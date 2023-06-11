extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func closest(values = [1,2], target=0):
	
	var first = true
	var runningTally
	var result
	for value in values:
		var tally = abs(target-value)
		if first:
			runningTally = tally
			result = value
			first = false
			continue
		if tally < runningTally:
			runningTally = tally
			result = value
	return result

func furthest(values, target=0):
	var runningTally = 0
	var result
	for value in values:
		var tally = abs(target-value)
		if tally > runningTally:
			runningTally = tally
			result = value
	return result
