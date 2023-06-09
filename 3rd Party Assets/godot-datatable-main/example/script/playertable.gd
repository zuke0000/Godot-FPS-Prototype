tool
extends DataTable
class_name PlayerTable

func _get_schema():
	return [
		SchemaColumn.new("name", TypeString.new(), ""),
		SchemaColumn.new("prefab", TypeObject.new("PackedScene"), null),
		SchemaColumn.new("enabled", TypeBool.new(), false),
	]
