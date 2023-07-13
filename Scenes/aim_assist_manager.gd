extends Node3D
@onready var exclusion_body = $"../../.."
@export var distance := 10.0
@onready var cone = $AimCone

# Called when the node enters the scene tree for the first time.
func _ready():
	cone.set_cone_scale_by_distance(distance)
	cone.add_exception(exclusion_body)
	
func get_assist_rotation(bullet_emitter, length_threshold):
	var body = cone.shoot_shapecast()
	if body:
		var pos = get_prioritized_pos(body, true)
		bullet_emitter.look_at(pos)
		# don't rotate if the aim is too far off
		if bullet_emitter.rotation.length() > length_threshold:
			bullet_emitter.rotation = Vector3(0,0,0)
			pos = get_prioritized_pos(body, false)
			bullet_emitter.look_at(pos)
		if bullet_emitter.rotation.length() > length_threshold:
			bullet_emitter.rotation = Vector3(0,0,0)
		return bullet_emitter

func get_prioritized_pos(body, head=true):
	if body.has_method("get_head_pos") and body.get_head_pos() and head:
		var pos = body.get_head_pos()
		return pos
	return body.global_transform.origin
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
