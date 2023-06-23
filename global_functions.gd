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

func despawn_time(node, time=7):
	await wait_time(time)
	node.queue_free()

func rolling_physics(node, delta, velocity, grav = 35, drag = 0.01, veloc_retained_on_bounce = 0.8):
	velocity += -velocity * drag + Vector3.DOWN * grav * delta
	var collision = node.move_and_collide(velocity * delta)
	
	# reflection equation
	
	if collision:
		var d = velocity
		var n = collision.normal
		var r = d - 2 * d.dot(n) * n
		velocity = r * veloc_retained_on_bounce

func random_rotate(node, rotation=deg_to_rad(45)):
	node.rotate_x(randf_range(-rotation, rotation))
	node.rotate_y(randf_range(-rotation, rotation))
	node.rotate_z(randf_range(-rotation, rotation))
	
