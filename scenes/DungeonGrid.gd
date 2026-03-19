extends Node2D

const ROOM_SIZE = 64

var grid_width: int
var grid_height: int
var grid: Array[Array]

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

func generate_dungeon():
	for y in range(grid_height):
		for x in range(grid_width):
			spawn_room(x, y)

func spawn_room(x: int, y: int) -> Node2D:
	var room = load("res://scenes/Room.tscn").instantiate()
	room.position = Vector2(x * ROOM_SIZE, y * ROOM_SIZE)
	room.name = "Room_%d_%d" % [x, y]
	add_child(room)
	grid[y][x] = room
	
	return room

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
