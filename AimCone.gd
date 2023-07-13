extends ShapeCast3D

@onready var self_collision_node
@export var distance := 40.0
@export var y_ratio = 1.0/8.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var scale_x = distance * y_ratio
	var scale_y = distance
	var scale_z = distance * y_ratio
	set_scale(Vector3(scale_x,scale_y,scale_z))
	

func set_cone_scale_by_distance(_distance=10.0):
	var scale_x = _distance * y_ratio
	var scale_y = _distance
	var scale_z = _distance * y_ratio
	set_scale(Vector3(scale_x,scale_y,scale_z))

	

func _on_timer_timeout():
	
	force_shapecast_update()
	if is_colliding():
		pass
		#print(get_collider(0))

func shoot_shapecast():
	force_shapecast_update()
	if is_colliding() and get_collider(0).has_method("hurt"):
		return get_collider(0)
	else:
		false


func shoot_raycast():
	#$RayCast.look_at(-global_transform.origin.z, Vector3.UP)
	$RayCast.force_raycast_update()
	#$RayCast.debug_shape_custom_color = Color(174,0,0)
	if $RayCast.is_colliding() and $RayCast.get_collider().has_method("hurt"):
		var collider = $RayCast.get_collider()
		print('found this body: ', collider)
		

