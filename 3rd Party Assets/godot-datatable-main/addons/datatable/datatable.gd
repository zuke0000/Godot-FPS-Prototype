tool
extends EditorPlugin

var inspector_plugin: DataTableInspectorPlugin

func _enter_tree():
	inspector_plugin = DataTableInspectorPlugin.new(self)
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(inspector_plugin)
