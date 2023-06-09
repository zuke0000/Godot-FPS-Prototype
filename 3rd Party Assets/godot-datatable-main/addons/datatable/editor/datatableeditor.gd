class_name DataTableEditor
extends EditorProperty

var plugin: EditorPlugin
var table_schema: Array
var row_count_lbl: Label
var table_grid: GridContainer

func _init(schema: Array, plugin: EditorPlugin):
	self.plugin = plugin
	self.table_schema = schema
	_setup_table_layout()

func update_property():
	_clear_table_cells()
	_populate_table()

func _setup_table_layout():
	var table_root := VBoxContainer.new()
	add_child(table_root)
	set_bottom_editor(table_root)
	
	var header_hbox := HBoxContainer.new()
	table_root.add_child(header_hbox)
	
	row_count_lbl = Label.new()
	row_count_lbl.size_flags_horizontal |= SIZE_EXPAND
	header_hbox.add_child(row_count_lbl)
	
	var add_btn := Button.new()
	add_btn.icon = _get_icon_by_name("Add")
	add_btn.connect("pressed", self, "_on_add_pressed")
	header_hbox.add_child(add_btn)
	
	table_grid = GridContainer.new()
	table_grid.size_flags_horizontal |= SIZE_EXPAND
	table_root.add_child(table_grid)

func _populate_table():
	var table_data = get_edited_object().get(get_edited_property())
	row_count_lbl.text = "Rows: %d" % [table_data.size()]
	
	table_grid.columns = table_schema.size() + 1
	for column in table_schema:
		var header_lbl := Label.new()
		header_lbl.text = column.name
		header_lbl.size_flags_horizontal |= SIZE_EXPAND
		table_grid.add_child(header_lbl)
	var delete_row_header := Control.new()
	table_grid.add_child(delete_row_header)
	
	for row_idx in range(0, table_data.size()):
		var row = table_data[row_idx]
		# TODO try work out which col was removed based on name before truncate
		_conform_row_to_schema(row)
		_populate_table_row(row, row_idx)

func _populate_table_row(row: Array, row_idx: int):
	for column_idx in range(0, row.size()):
		var column = row[column_idx]
		var column_schema = table_schema[column_idx]
		var control := _get_control_for_data_type(column_schema.type, row, column_idx)
		table_grid.add_child(control)
	
	# add delete button as last column
	var delete_btn := Button.new()
	delete_btn.icon = _get_icon_by_name("Remove")
	delete_btn.connect("pressed", self, "_on_delete_row_pressed", [row_idx])
	table_grid.add_child(delete_btn)

# Ensure that existing table rows conform to the schema (in case it changes)
# NOTE: this is lossy - changing the schema may result in data being lost
func _conform_row_to_schema(row: Array):
	if row.size() < table_schema.size():
		# new columns added to the schema, append new defaults to row:
		for i in range(row.size(), table_schema.size()):
			row.append(table_schema[i].default)
	elif row.size() > table_schema.size():
		# columns removed from schema, truncate row:
		row.resize(table_schema.size())
	
	for column_idx in range(0, row.size()):
		var column = row[column_idx]
		var schema = table_schema[column_idx]
		# if data type stored does not match schema, erase and replace with default
		if typeof(column) != schema.type.id():
			row[column_idx] = schema.default

func _clear_table_cells():
	for child in table_grid.get_children():
		table_grid.remove_child(child)
		child.queue_free()

func _get_control_for_data_type(type, row, column_idx) -> Control:
	var control: Control
	match type.id():
		TYPE_BOOL:
			control = CheckBox.new()
			control.pressed = row[column_idx]
			control.size_flags_horizontal |= Control.SIZE_EXPAND
			control.connect("toggled", self, "_on_value_changed", [row, column_idx])
		TYPE_INT:
			control = SpinBox.new()
			control.step = 1
			control.min_value = type.min_value
			control.max_value = type.max_value
			control.value = row[column_idx]
			control.size_flags_horizontal |= Control.SIZE_EXPAND
			control.connect("value_changed", self, "_on_value_changed_int", [row, column_idx])
		TYPE_REAL:
			control = SpinBox.new()
			control.step = 0.0001
			control.value = row[column_idx]
			control.min_value = type.min_value
			control.max_value = type.max_value
			control.size_flags_horizontal |= Control.SIZE_EXPAND
			control.connect("value_changed", self, "_on_value_changed_float", [row, column_idx])
		TYPE_STRING:
			control = LineEdit.new()
			control.text = row[column_idx]
			control.size_flags_horizontal |= Control.SIZE_EXPAND
			control.connect("text_changed", self, "_on_value_changed", [row, column_idx])
		TYPE_OBJECT:
			control = EditorResourcePicker.new()
			control.edited_resource = row[column_idx]
			control.base_type = type.allowed_types
			control.size_flags_horizontal |= Control.SIZE_EXPAND
			control.connect("resource_changed", self, "_on_value_changed", [row, column_idx])
		_:
			control = Label.new()
			control.text = "unknown type"
			control.size_flags_horizontal |= Control.SIZE_EXPAND
	return control

func _on_add_pressed():
	var row: Array = []
	for column in table_schema:
		row.append(column.default)
	var table_data = get_edited_object().get(get_edited_property())
	table_data.append(row)
	emit_changed(get_edited_property(), table_data)

func _on_delete_row_pressed(rowidx):
	var table_data = get_edited_object().get(get_edited_property())
	table_data.remove(rowidx)
	emit_changed(get_edited_property(), table_data)

func _on_value_changed(value, row, column_idx):
	row[column_idx] = value
	var table_data = get_edited_object().get(get_edited_property())
	emit_changed(get_edited_property(), table_data, "", true)

func _on_value_changed_int(value, row, column_idx):
	_on_value_changed(int(value), row, column_idx)

func _on_value_changed_float(value, row, column_idx):
	print(float(value))
	_on_value_changed(float(value), row, column_idx)

func _get_icon_by_name(name: String):
	var gui := plugin.get_editor_interface().get_base_control()
	return gui.get_icon(name, "EditorIcons")
