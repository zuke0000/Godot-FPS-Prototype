extends Node

# TODO convert to native resource type to allow for typed export
var levels: DataTable = preload("res://example/data/levels.tres")
var players: DataTable = preload("res://example/data/players.tres")

func _ready():
	var query = levels.create_query() \
		.greater("xp to level", 1) \
		.greater_or_equal("extra hp", 1)
	print("Found Levels: %d" % [query.size()])
	for result in query.results():
		# TODO allow for named column access (e.g. result.level)
		print("- Level %d: (xp=%f), (icon=%s)" % [result[0], result[1], result[3]])
	
	query = players.create_query() \
		.equal("enabled", true)
	print("Found Players: %d" % [query.size()])
	for result in query.results():
		print("- %s: (prefab=%s)" % [result[0], result[1]])
