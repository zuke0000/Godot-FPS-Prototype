tool
extends DataTable
class_name LevelTable

func _get_schema():
	return [
		SchemaColumn.new("level", TypeInt.new(1, 10), 1),
		SchemaColumn.new("xp to level", TypeFloat.new(0.0, 100.0), 0.0),
		SchemaColumn.new("extra hp", TypeInt.new(), 0),
		SchemaColumn.new("achievement icon", TypeObject.new("Texture"), null),
	]
