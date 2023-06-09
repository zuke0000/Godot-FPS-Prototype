tool
extends Resource
class_name DataTable

const MIN_INT: int = -9223372036854775807
const MAX_INT: int = 9223372036854775807
const MIN_FLOAT: float = -1.79769e308
const MAX_FLOAT: float = 1.79769e308

# Table is stored as array-of-arrays
# Outer array contains rows, each row is array of column data
export var table_data: Array

# Tables should override this to return an array of SchemaColumn
func _get_schema() -> Array:
	return []

# Get the number of rows in the table
func size() -> int:
	return table_data.size()
	
# Get the row by index
func get_row_by_index(index: int) -> Array:
	assert(index > 0 and index < size(), "Index out of range")
	return table_data[index]
	
# Get index of column matching given name
func get_column_index(column_name: String) -> int:
	var schema = _get_schema()
	for columnidx in range(0, schema.size()):
		var column = schema[columnidx]
		if column.name == column_name:
			return columnidx
	return -1

# Create a new query for searching this table
func create_query() -> DataTableQuery:
	var query = DataTableQuery.new(self)
	query._results = table_data
	return query

# Fetch the value of column by row index & column name
func get_column_value(row_index: int, column_name: String):
	assert(row_index > 0 and row_index < size(), "Row index out of range")
	var columnidx = get_column_index(column_name)
	assert(columnidx != -1, "Column name not found in table schema")
	return table_data[row_index][columnidx]

class SchemaColumn:
	var name: String
	var type: SchemaType
	var default
	
	func _init(name: String, type: SchemaType, default):
		self.name = name
		self.type = type
		self.default = default

class SchemaType:
	
	func id() -> int:
		return TYPE_NIL

class TypeBool:
	extends SchemaType
	
	func id() -> int:
		return TYPE_BOOL

class TypeInt:
	extends SchemaType
	
	var min_value: int
	var max_value: int
	
	func _init(min_value = MIN_INT, max_value = MAX_INT):
		self.min_value = min_value
		self.max_value = max_value
	
	func id() -> int:
		return TYPE_INT

class TypeFloat:
	extends SchemaType
	
	var min_value: float
	var max_value: float
	
	func _init(min_value = MIN_FLOAT, max_value = MAX_FLOAT):
		self.min_value = min_value
		self.max_value = max_value
	
	func id() -> int:
		return TYPE_REAL

class TypeString:
	extends SchemaType
	
	func id() -> int:
		return TYPE_STRING

class TypeObject:
	extends SchemaType
	
	var allowed_types: String
	
	# allowed_types accepts a comma separated String of type names
	func _init(allowed_types: String = ""):
		self.allowed_types = allowed_types
	
	func id() -> int:
		return TYPE_OBJECT

# Helper class for searching the contents of a Table
class DataTableQuery:
	var _table: DataTable
	var _results: Array
	
	func _init(table: DataTable, results: Array = []):
		self._table = table
		self._results = results
	
	func equal(column_name: String, column_value) -> DataTableQuery:
		var filterResults := []
		var columnidx = _table.get_column_index(column_name)
		assert(columnidx != -1, "Column name not found in table schema")
		
		for row in _results:
			if row[columnidx] == column_value:
				filterResults.append(row)
				
		return DataTableQuery.new(_table, filterResults)
	
	func not_equal(column_name: String, column_value) -> DataTableQuery:
		var filterResults := []
		var columnidx = _table.get_column_index(column_name)
		assert(columnidx != -1, "Column name not found in table schema")
		
		for row in _results:
			if row[columnidx] != column_value:
				filterResults.append(row)
				
		return DataTableQuery.new(_table, filterResults)
	
	func greater(column_name: String, column_value) -> DataTableQuery:
		var filterResults := []
		var columnidx = _table.get_column_index(column_name)
		assert(columnidx != -1, "Column name not found in table schema")
		
		for row in _results:
			if row[columnidx] > column_value:
				filterResults.append(row)
				
		return DataTableQuery.new(_table, filterResults)
	
	func less_than(column_name: String, column_value) -> DataTableQuery:
		var filterResults := []
		var columnidx = _table.get_column_index(column_name)
		assert(columnidx != -1, "Column name not found in table schema")
		
		for row in _results:
			if row[columnidx] < column_value:
				filterResults.append(row)
				
		return DataTableQuery.new(_table, filterResults)
	
	func greater_or_equal(column_name: String, column_value) -> DataTableQuery:
		var filterResults := []
		var columnidx = _table.get_column_index(column_name)
		assert(columnidx != -1, "Column name not found in table schema")
		
		for row in _results:
			if row[columnidx] >= column_value:
				filterResults.append(row)
				
		return DataTableQuery.new(_table, filterResults)
	
	func less_than_or_equal(column_name: String, column_value) -> DataTableQuery:
		var filterResults := []
		var columnidx = _table.get_column_index(column_name)
		assert(columnidx != -1, "Column name not found in table schema")
		
		for row in _results:
			if row[columnidx] <= column_value:
				filterResults.append(row)
				
		return DataTableQuery.new(_table, filterResults)
	
	# Return the number of results in this search
	func size() -> int:
		return _results.size()
	
	func results() -> Array:
		return self._results
	
	# Fetch the value of column by results index & column name
	func get_column_value(result_index: int, column_name: String):
		assert(result_index > 0 and result_index < _results.size(), "Result index out of range")
		var columnidx = _table.get_column_index(column_name)
		assert(columnidx != -1, "Column name not found in table schema")
		return _results[result_index][columnidx]
