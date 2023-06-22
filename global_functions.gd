extends Node

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

## Creates a timer
## @time amount in seconds to wait
## Usage:
##		await GlobalFunctions.wait_time(3) # 
func wait_time(time):
	#print('ran')
	var timer_node = get_tree().create_timer(time)
	await timer_node.timeout
	#print('return')
	return 
