extends Node2D

# Paladin auto-moves through dungeon rooms.
const Room = preload("res://scenes/Room.gd")
var dungeon_grid : Node = null
var current_room : Node2D = null
const MOVE_SPEED := 200.0 # pixels per second

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
	var exits = []
	for dir in [Room.ExitDirection.NORTH, Room.ExitDirection.SOUTH, Room.ExitDirection.EAST, Room.ExitDirection.WEST]:
		if current_room.has_exit(dir):
			exits.append(dir)
	if exits.is_empty():
		await get_tree().create_timer(1.0).timeout
		move_to_next_room()
		return
	var dir = exits[randi_range(0, exits.size()-1)]
	var next_pos = dungeon_grid.get_neighbor_position(current_room.position, dir)
	if not next_pos:
		await get_tree().create_timer(0.5).timeout
		move_to_next_room()
		return
	var nx = int(next_pos.x / dungeon_grid.ROOM_SIZE)
	var ny = int(next_pos.y / dungeon_grid.ROOM_SIZE)
	var target_node = dungeon_grid.get_room(nx, ny)
	if not target_node:
		await get_tree().create_timer(0.5).timeout
		move_to_next_room()
		return
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_node.global_position + Vector2(32,32), target_node.position.distance_to(current_room.position)/MOVE_SPEED)
	await tween.finished
	current_room = target_node
	await get_tree().create_timer(0.5).timeout
	move_to_next_room()
