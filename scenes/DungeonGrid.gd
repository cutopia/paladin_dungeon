extends Node2D

const ROOM_SIZE = 64

var grid_width: int
var grid_height: int
var grid: Array[Array]

enum ExitDirection {
	NORTH = 0,
	SOUTH = 1,
	EAST = 2,
	WEST = 3
}

func _ready():
	grid_width = 3
	grid_height = 3
	grid = []
	
	for y in range(grid_height):
		var row = []
		for x in range(grid_width):
			row.append(null)
		grid.append(row)
	
	generate_dungeon()

func generate_new_level(start_x: int, start_y: int) -> void:
	# Clear existing grid
	for y in range(grid_height):
		for x in range(grid_width):
			if grid[y][x]:
				grid[y][x].queue_free()
				grid[y][x] = null
	
	# Generate new dungeon
	generate_dungeon()
	
	# Place stairwell (not in starting room)
	place_stairwell(start_x, start_y)

func generate_dungeon():
	for y in range(grid_height):
		for x in range(grid_width):
			spawn_room(x, y)
	
	# Place stairwell in a random room (not at 0,0 initially)
	place_stairwell(0, 0)

func spawn_room(x: int, y: int) -> Node2D:
	var room = load("res://scenes/Room.tscn").instantiate()
	room.position = Vector2(x * ROOM_SIZE, y * ROOM_SIZE)
	room.name = "Room_%d_%d" % [x, y]
	add_child(room)
	grid[y][x] = room
	
	return room

func place_stairwell(start_x: int, start_y: int):
	# Find a random room that's not the starting position
	var total_rooms = grid_width * grid_height
	var max_attempts = total_rooms * 2
	var attempts = 0
	
	while attempts < max_attempts:
		var rand_x = randi_range(0, grid_width - 1)
		var rand_y = randi_range(0, grid_height - 1)
		
		# Don't place in starting room
		if rand_x != start_x or rand_y != start_y:
			var room = get_room(rand_x, rand_y)
			if room:
				room.set_has_stairwell(true)
				print("Stairwell placed at room (%d, %d)" % [rand_x, rand_y])
				return true
		
		attempts += 1
	
	print("Failed to place stairwell after max attempts")
	return false

func get_room(x: int, y: int) -> Node2D:
	if is_valid_grid_position(x, y):
		return grid[y][x]
	return null

func is_valid_grid_position(x: int, y: int) -> bool:
	return x >= 0 and x < grid_width and y >= 0 and y < grid_height

func get_neighbor(x: int, y: int, direction) -> Node2D:
	match(direction):
		"north":
			return get_room(x, y - 1)
		"south":
			return get_room(x, y + 1)
		"east":
			return get_room(x + 1, y)
		"west":
			return get_room(x - 1, y)
	return null

func get_neighbor_position(position: Vector2, direction) -> Vector2:
	var x = int(position.x / ROOM_SIZE)
	var y = int(position.y / ROOM_SIZE)
	
	match(direction):
		ExitDirection.NORTH:
			return Vector2(x * ROOM_SIZE, (y - 1) * ROOM_SIZE)
		ExitDirection.SOUTH:
			return Vector2(x * ROOM_SIZE, (y + 1) * ROOM_SIZE)
		ExitDirection.EAST:
			return Vector2((x + 1) * ROOM_SIZE, y * ROOM_SIZE)
		ExitDirection.WEST:
			return Vector2((x - 1) * ROOM_SIZE, y * ROOM_SIZE)
	return position
