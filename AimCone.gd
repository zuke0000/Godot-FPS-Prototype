extends ShapeCast3D

@onready var self_collision_node
@onready var raycast = $RayCast
@export var distance := 40.0
@export var y_ratio = 1.0/8.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var scale_x = distance * y_ratio
	var scale_y = distance
	var scale_z = distance * y_ratio
	set_scale(Vector3(scale_x,scale_y,scale_z))

func set_self_collision_node(node):
	self_collision_node = node

func set_cone_scale_by_distance(_distance=10.0):
	var scale_x = _distance * y_ratio
	var scale_y = _distance
	var scale_z = _distance * y_ratio
	set_scale(Vector3(scale_x,scale_y,scale_z))

	
# let enemies know you're looking at them
func _on_timer_timeout():
	force_shapecast_update()
	if is_colliding() and get_collider(0).has_method("looking_at"):
		get_collider(0).looking_at()

func shoot_shapecast():
	force_shapecast_update()
	if is_colliding() and get_collider(0).has_method("hurt"):
		return get_collider(0)
	else:
		false

func raycast_check():
	var collider = false
	#$RayCast.look_at(-global_transform.origin.z, Vector3.UP)
	raycast.force_raycast_update()
	raycast.add_exception(self_collision_node)
	raycast.debug_shape_custom_color = Color(174,0,0)
	#raycast.look_at(body.global_transform.origin.z)
	if raycast.is_colliding() and raycast.get_collider().has_method("hurt"):
		print('raycast looking at: ', raycast.get_collider())
		#collider = raycast.get_collider()
		return true
	return false
		

