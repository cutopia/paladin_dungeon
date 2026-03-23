extends Node2D

const Room = preload("res://scenes/Room.tscn")
const ROOM_SIZE = 64

func _ready():
	print("=== Test Map Setup ===")
	
	# Clear existing rooms
	for child in get_children():
		if child is Room:
			child.queue_free()
	
	# Create a 3x3 grid with controlled exit configurations
	for y in range(3):
		for x in range(3):
			var room = Room.instantiate()
			room.position = Vector2(x * ROOM_SIZE, y * ROOM_SIZE)
			room.name = "Room_%d_%d" % [x, y]
			
			# Set specific exit configuration
			if x == 0 and y == 0:
				# Top-left corner: stairwell with EAST and SOUTH exits
				room.set_exit_mask(12)  # EAST | SOUTH = 4 + 8 = 12
				room.set_has_stairwell(true)
				print("Room (0,0): Stairwell with EAST+SOUTH exits")
			elif x == 1 and y == 0:
				# Room to the right of (0,0): WEST exit only
				room.set_exit_mask(8)  # WEST = 8
				print("Room (1,0): WEST exit only")
			elif x == 0 and y == 1:
				# Room below (0,0): NORTH exit only  
				room.set_exit_mask(1)  # NORTH = 1
				print("Room (0,1): NORTH exit only")
			else:
				# Other rooms: random exits
				var mask = randi_range(1, 15)
				room.set_exit_mask(mask)
			
			add_child(room)
	
	print("\nMap setup complete. Try moving paladin to (0,0) stairwell.")
