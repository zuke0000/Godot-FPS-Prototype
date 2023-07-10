extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init(from,to):
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES,
								material_override)
	draw_mesh.surface_add_vertex(from)
	draw_mesh.surface_add_vertex(to)
	draw_mesh.surface_end()
	await GlobalFunctions.wait_time(0.15)
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
