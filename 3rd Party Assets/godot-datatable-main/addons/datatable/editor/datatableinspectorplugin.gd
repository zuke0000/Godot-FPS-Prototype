class_name DataTableInspectorPlugin
extends EditorInspectorPlugin

var schema: Array = []
var plugin: EditorPlugin

func _init(plugin: EditorPlugin):
	self.plugin = plugin

func can_handle(object):
	return object is DataTable

func parse_begin(object):
	self.schema = (object as DataTable)._get_schema()

func parse_property(object, type, path, hint, hint_text, usage):
	if path == "table_data":
		add_property_editor(path, DataTableEditor.new(schema, plugin))
		return true
	return false
