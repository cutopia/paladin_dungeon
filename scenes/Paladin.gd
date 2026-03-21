extends Node2D

# Paladin auto-moves through dungeon rooms.
const Room = preload("res://scenes/Room.gd")
var dungeon_grid: Node = null
var current_room: Node2D = null
const MOVE_SPEED := 150.0 # pixels per second

enum ExitDirection {
	NORTH = 0,
	SOUTH = 1,
	EAST = 2,
	WEST = 3
}

func _ready():
	# Find the DungeonGrid node (assumed first child of parent)
	var children = get_parent().get_children()
	dungeon_grid = children[0] if children.size() > 0 else null
	
	if not dungeon_grid or not dungeon_grid.has_method("get_room"):
		push_error("Paladin: DungeonGrid node not found")
		return
	
	# Spawn in a random room
	var idx = get_random_room_indices()
	current_room = dungeon_grid.get_room(idx.x, idx.y)
	
	if current_room:
		global_position = current_room.global_position + Vector2(32, 32) # center of room
		await get_tree().create_timer(0.5).timeout
		move_to_next_room()

func get_random_room_indices() -> Vector2i:
	var w = dungeon_grid.grid_width
	var h = dungeon_grid.grid_height
	return Vector2i(randi_range(0, w-1), randi_range(0, h-1))

func move_to_next_room():
	if not current_room:
		return
	
	# Get available exits from current room
	var exits = []
	for dir in [ExitDirection.NORTH, ExitDirection.SOUTH, ExitDirection.EAST, ExitDirection.WEST]:
		if current_room.has_exit(dir):
			exits.append(dir)
	
	if exits.is_empty():
		print("No exits available in current room")
		await get_tree().create_timer(1.0).timeout
		move_to_next_room()
		return
	
	# Pick a random exit direction
	var dir = exits[randi_range(0, exits.size()-1)]
	
	# Get the target room position and node
	var next_pos = dungeon_grid.get_neighbor_position(current_room.position, dir)
	if not next_pos:
		print("No valid neighbor in direction: ", dir)
		await get_tree().create_timer(0.5).timeout
		move_to_next_room()
		return
	
	var nx = int(next_pos.x / dungeon_grid.ROOM_SIZE)
	var ny = int(next_pos.y / dungeon_grid.ROOM_SIZE)
	
	var target_node = dungeon_grid.get_room(nx, ny)
	if not target_node:
		print("Target room not found at: ", nx, ny)
		await get_tree().create_timer(0.5).timeout
		move_to_next_room()
		return
	
	# Check if the target room has a matching exit (connection is bidirectional)
	var opposite_dir = get_opposite_direction(dir)
	if not target_node.has_exit(opposite_dir):
		print("Target room doesn't have exit in opposite direction: ", opposite_dir)
		await get_tree().create_timer(0.5).timeout
		move_to_next_room()
		return
	
	# Animate movement to the next room
	var distance = current_room.position.distance_to(target_node.position)
	var duration = distance / MOVE_SPEED
	
	print("Moving from room at ", int(current_room.position.x/dungeon_grid.ROOM_SIZE), 
	      ",", int(current_room.position.y/dungeon_grid.ROOM_SIZE), 
	      " to ", nx, ",", ny, " (direction: ", dir, ")")
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_node.global_position + Vector2(32, 32), duration)
	await tween.finished
	
	current_room = target_node
	print("Arrived at new room")
	
	# Wait briefly before moving again
	await get_tree().create_timer(0.5).timeout
	move_to_next_room()

func get_opposite_direction(direction) -> int:
	match direction:
		ExitDirection.NORTH: return ExitDirection.SOUTH
		ExitDirection.SOUTH: return ExitDirection.NORTH
		ExitDirection.EAST: return ExitDirection.WEST
		ExitDirection.WEST: return ExitDirection.EAST
	return -1
