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

# Combat stats
var max_health: int = 50
var health: int = 50
var attack: int = 8
var experience: int = 0
var level: int = 1

# UI Labels
var attack_label: Label3D = null
var health_label: Label3D = null

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
		create_health_attack_labels()
		await get_tree().create_timer(0.5).timeout
		move_to_next_room()

func create_health_attack_labels() -> void:
	# Create attack label (top)
	attack_label = Label3D.new()
	attack_label.position = Vector3(0, -20, 0)
	attack_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	attack_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	add_child(attack_label)
	
	# Create health label (bottom)
	health_label = Label3D.new()
	health_label.position = Vector3(0, 20, 0)
	health_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	health_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	add_child(health_label)
	
	update_labels()

func update_labels() -> void:
	if attack_label:
		attack_label.text = "⚔️ %d" % attack
	if health_label:
		health_label.text = "%d ❤️" % health

func get_random_room_indices() -> Vector2i:
	var w = dungeon_grid.grid_width
	var h = dungeon_grid.grid_height
	return Vector2i(randi_range(0, w-1), randi_range(0, h-1))

func move_to_next_room():
	if not current_room:
		return
	
	# Get available exits from current room (only those that lead to valid neighbors)
	var exits = []
	for dir in [ExitDirection.NORTH, ExitDirection.SOUTH, ExitDirection.EAST, ExitDirection.WEST]:
		if not current_room.has_exit(dir):
			continue
		
		# Check if neighbor exists
		var next_pos = dungeon_grid.get_neighbor_position(current_room.position, dir)
		if not next_pos:
			continue
			
		var nx = int(next_pos.x / dungeon_grid.ROOM_SIZE)
		var ny = int(next_pos.y / dungeon_grid.ROOM_SIZE)
		
		if not dungeon_grid.is_valid_grid_position(nx, ny):
			continue
		
		var target_node = dungeon_grid.get_room(nx, ny)
		if not target_node:
			continue
		
		# Check if target has matching exit
		var opposite_dir = get_opposite_direction(dir)
		if not target_node.has_exit(opposite_dir):
			continue
		
		exits.append(dir)
	
	if exits.is_empty():
		print("No valid exits available in current room after checking neighbors")
		await get_tree().create_timer(1.0).timeout
		move_to_next_room()
		return
	
	# Pick a random exit direction
	var dir = exits[randi_range(0, exits.size()-1)]
	
	# Get the target room position and node (already computed in loop above)
	var next_pos = dungeon_grid.get_neighbor_position(current_room.position, dir)
	var nx = int(next_pos.x / dungeon_grid.ROOM_SIZE)
	var ny = int(next_pos.y / dungeon_grid.ROOM_SIZE)
	
	var target_node = dungeon_grid.get_room(nx, ny)
	
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
	
	# Check if this room has a monster
	if current_room.has_monster():
		await handle_combat(current_room.get_monster())
	
	# Check if this room has a stairwell
	if current_room.has_stairwell:
		print("Paladin reached the stairwell! Descending to next level...")
		await handle_stairwell()
	
	# Wait briefly before moving again
	await get_tree().create_timer(0.5).timeout
	move_to_next_room()

func handle_combat(monster: Node2D) -> void:
	print("Combat started with monster!")
	
	# Get monster stats from its script
	var monster_health = monster.health
	var monster_attack = monster.damage
	
	while health > 0 and monster_health > 0:
		# Paladin attacks monster
		monster_health -= attack
		print("Paladin hits monster for ", attack, " damage. Monster has ", monster_health, " HP left")
		
		# Update labels
		update_labels()
		if current_room.has_monster():
			current_room.get_monster().update_labels()
		
		# Visual feedback: flash room red
		flash_room_red()
		
		if monster_health <= 0:
			break
		
		# Monster attacks paladin
		health -= monster_attack
		print("Monster hits paladin for ", monster_attack, " damage. Paladin has ", health, " HP left")
		
		# Update labels
		update_labels()
		
		# Visual feedback: flash room red (paladin taking damage)
		flash_room_red()
		
		# Small delay between attacks
		await get_tree().create_timer(0.3).timeout
	
	if health <= 0:
		print("Paladin defeated!")
		queue_free()
	else:
		print("Monster defeated! Gaining ", monster.exp_reward, " experience")
		gain_experience(monster.exp_reward)
		
		# Remove the monster from the room
		current_room.get_monster().queue_free()
		current_room.monster = null
		
		# Wait briefly after combat before moving again
		await get_tree().create_timer(1.0).timeout

func gain_experience(exp: int) -> void:
	experience += exp
	print("Paladin gained ", exp, " experience. Total: ", experience)
	
	# Level up every 100 experience points (simple progression)
	if experience >= level * 100:
		level_up()

func level_up() -> void:
	level += 1
	max_health += 10
	health = max_health
	attack += 2
	update_labels()
	print("Level up! Now level ", level, " with ", attack, " attack and ", max_health, " health")

func flash_room_red() -> void:
	if not current_room:
		return
	
	# Get the room's ColorRect or create one if needed
	var color_rect = null
	
	# Try to find existing ColorRect in room
	for child in current_room.get_children():
		if child is ColorRect:
			color_rect = child
			break
	
	# If no ColorRect found, we'll flash the room directly
	if not color_rect:
		# Create a temporary overlay
		var overlay = ColorRect.new()
		overlay.size = Vector2(64, 64)
		overlay.position = Vector2(0, 0)
		current_room.add_child(overlay)
		color_rect = overlay
	
	# Flash red with more visibility
	var tween = create_tween().set_loops(3)
	tween.tween_property(color_rect, "modulate", Color(1.0, 0.0, 0.0, 0.7), 0.05)
	tween.tween_property(color_rect, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.05)

func handle_stairwell() -> void:
	var old_x = int(current_room.position.x / dungeon_grid.ROOM_SIZE)
	var old_y = int(current_room.position.y / dungeon_grid.ROOM_SIZE)
	
	# Generate new level with current paladin's old room position as start
	dungeon_grid.generate_new_level(old_x, old_y)
	
	# Find a random room in the new level for the paladin
	var idx = get_random_room_indices()
	current_room = dungeon_grid.get_room(idx.x, idx.y)
	
	if current_room:
		global_position = current_room.global_position + Vector2(32, 32) # center of room

func get_opposite_direction(direction) -> int:
	match direction:
		ExitDirection.NORTH: return ExitDirection.SOUTH
		ExitDirection.SOUTH: return ExitDirection.NORTH
		ExitDirection.EAST: return ExitDirection.WEST
		ExitDirection.WEST: return ExitDirection.EAST
	return -1
