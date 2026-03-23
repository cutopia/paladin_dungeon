extends Node

# ScenarioLoader - Loads custom dungeon layouts for debugging
#
# Usage:
#   1. Create a scenario file (JSON format) defining room layouts
#   2. Run Godot with --scenario <path_to_file> command line argument
#   3. The dungeon will be generated according to your specification
#
# Scenario File Format:
# {
#   "width": 3,
#   "height": 3,
#   "start_position": [0, 0],
#   "rooms": [
#     {"x": 0, "y": 0, "exits": ["N", "E"], "has_stairwell": false},
#     {"x": 1, "y": 0, "exits": ["S", "W"], "has_stairwell": false},
#     ...
#   ]
# }
#
# Exit directions: "N" (North), "S" (South), "E" (East), "W" (West)
# has_stairwell: true/false - marks the room with a staircase
#
# Examples:
#   godot --scenario=scenarios/debug_room_rotation.json
#   godot --scenario=scenarios/test_connectivity.json

const ROOM_SIZE = 64

var grid_width: int = 3
var grid_height: int = 3
var start_position: Array = [0, 0]
var rooms_data: Array = []

func load_scenario(file_path: String) -> bool:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Error: Could not open scenario file: ", file_path)
		return false
	
	var content = file.get_as_text()
	file.close()
	
	var parser = JSON.new()
	var error = parser.parse(content)
	if error != OK:
		print("Error parsing scenario JSON: ", parser.get_error_message())
		return false
	
	var result = parser.data
	if typeof(result) != TYPE_DICTIONARY:
		print("Error: Scenario file must contain a JSON object")
		return false
	
	# Parse grid dimensions
	grid_width = result.get("width", 3)
	grid_height = result.get("height", 3)
	
	# Parse start position
	var pos = result.get("start_position", [0, 0])
	if pos is Array and pos.size() >= 2:
		start_position = [pos[0], pos[1]]
	else:
		start_position = [0, 0]
	
	# Parse rooms
	rooms_data = result.get("rooms", [])
	
	print("Scenario loaded: %dx%d grid, start at [%d,%d], %d rooms defined" % 
		  [grid_width, grid_height, start_position[0], start_position[1], rooms_data.size()])
	
	return true

func apply_to_dungeon_grid(dungeon_grid: Node2D) -> void:
	# Set grid dimensions
	dungeon_grid.grid_width = grid_width
	dungeon_grid.grid_height = grid_height
	
	# Reinitialize grid array with new dimensions
	dungeon_grid.grid = []
	for y in range(grid_height):
		var row = []
		for x in range(grid_width):
			row.append(null)
		dungeon_grid.grid.append(row)
	
	# Clear existing nodes
	for child in dungeon_grid.get_children():
		if child is Node2D and child != dungeon_grid:
			child.queue_free()
	
	# Create rooms according to scenario
	for room_data in rooms_data:
		var x = room_data.get("x", 0)
		var y = room_data.get("y", 0)
		
		if dungeon_grid.is_valid_grid_position(x, y):
			var room = dungeon_grid.spawn_room(x, y)
			
			# Set exits using the room's set_exit_mask method
			var exits = room_data.get("exits", [])
			set_exits_for_room(room, exits)
			
			# Set stairwell if specified
			if room_data.has("has_stairwell"):
				room.set_has_stairwell(room_data["has_stairwell"])
	
	print("Scenario applied to dungeon grid")

func set_exits_for_room(room: Node2D, exits_array: Array) -> void:
	var exit_map = {
		"N": 1,
		"S": 2,
		"E": 4,
		"W": 8
	}
	
	var mask = 0
	for exit in exits_array:
		if exit_map.has(exit):
			mask |= exit_map[exit]
	
	room.set_exit_mask(mask)

func get_start_position() -> Vector2:
	return Vector2(start_position[0] * ROOM_SIZE, start_position[1] * ROOM_SIZE)
