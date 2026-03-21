extends Node2D

enum ExitDirection {
	NORTH = 0,
	SOUTH = 1,
	EAST = 2,
	WEST = 3
}

const EXIT_FLAGS = {
	ExitDirection.NORTH: 1,
	ExitDirection.SOUTH: 2,
	ExitDirection.EAST: 4,
	ExitDirection.WEST: 8
}

@onready var exit_n = $ExitN
@onready var exit_s = $ExitS
@onready var exit_e = $ExitE
@onready var exit_w = $ExitW
@onready var stairs_icon = $StairsIcon

var exits = {
	ExitDirection.NORTH: false,
	ExitDirection.SOUTH: false,
	ExitDirection.EAST: false,
	ExitDirection.WEST: false
}

func _ready():
	generate_random_exits()
	log_walls_status()
	update_exit_visuals()

func generate_random_exits():
	var num_exits = randi_range(1, 3)
	var directions = [ExitDirection.NORTH, ExitDirection.SOUTH, ExitDirection.EAST, ExitDirection.WEST]
	shuffle_array(directions)
	
	exits = {
		ExitDirection.NORTH: false,
		ExitDirection.SOUTH: false,
		ExitDirection.EAST: false,
		ExitDirection.WEST: false
	}
	
	for i in range(num_exits):
		exits[directions[i]] = true

func shuffle_array(arr):
	for i in range(arr.size() - 1, 0, -1):
		var j = randi_range(0, i)
		var temp = arr[i]
		arr[i] = arr[j]
		arr[j] = temp

func update_exit_visuals():
	exit_n.visible = !exits[ExitDirection.NORTH]
	exit_s.visible = !exits[ExitDirection.SOUTH]
	exit_e.visible = !exits[ExitDirection.EAST]
	exit_w.visible = !exits[ExitDirection.WEST]

func log_walls_status():
	var status = "Room at (%d, %d) walls:" % [position.x / 64, position.y / 64]
	if exits[ExitDirection.NORTH]:
		status += " N(open)"
	else:
		status += " N(blocked)"
	if exits[ExitDirection.SOUTH]:
		status += " S(open)"
	else:
		status += " S(blocked)"
	if exits[ExitDirection.EAST]:
		status += " E(open)"
	else:
		status += " E(blocked)"
	if exits[ExitDirection.WEST]:
		status += " W(open)"
	else:
		status += " W(blocked)"
	print(status)

func has_exit(direction):
	return exits[direction]

func rotate_cw():
	var new_exits = {
		ExitDirection.NORTH: false,
		ExitDirection.SOUTH: false,
		ExitDirection.EAST: false,
		ExitDirection.WEST: false
	}
	
	new_exits[ExitDirection.NORTH] = exits[ExitDirection.WEST]
	new_exits[ExitDirection.WEST] = exits[ExitDirection.SOUTH]
	new_exits[ExitDirection.SOUTH] = exits[ExitDirection.EAST]
	new_exits[ExitDirection.EAST] = exits[ExitDirection.NORTH]
	
	exits = new_exits
	update_exit_visuals()

func rotate_ccw():
	var new_exits = {
		ExitDirection.NORTH: false,
		ExitDirection.SOUTH: false,
		ExitDirection.EAST: false,
		ExitDirection.WEST: false
	}
	
	new_exits[ExitDirection.NORTH] = exits[ExitDirection.EAST]
	new_exits[ExitDirection.EAST] = exits[ExitDirection.SOUTH]
	new_exits[ExitDirection.SOUTH] = exits[ExitDirection.WEST]
	new_exits[ExitDirection.WEST] = exits[ExitDirection.NORTH]
	
	exits = new_exits
	update_exit_visuals()

func rotate_visual_feedback():
	var tween = create_tween().set_loops(1)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.05)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var room_rect = Rect2(position, Vector2(64, 64))
		if room_rect.has_point(event.position):
			print("Room clicked at position: ", event.position)
			if event.shift_pressed:
				print("Shift-click detected, rotating counterclockwise")
				rotate_ccw()
				rotate_visual_feedback()
			else:
				print("Normal click detected, rotating clockwise")
				rotate_cw()
				rotate_visual_feedback()

func get_exit_mask():
	var mask = 0
	if exits[ExitDirection.NORTH]:
		mask |= EXIT_FLAGS[ExitDirection.NORTH]
	if exits[ExitDirection.SOUTH]:
		mask |= EXIT_FLAGS[ExitDirection.SOUTH]
	if exits[ExitDirection.EAST]:
		mask |= EXIT_FLAGS[ExitDirection.EAST]
	if exits[ExitDirection.WEST]:
		mask |= EXIT_FLAGS[ExitDirection.WEST]
	return mask

func set_exit_mask(mask):
	exits[ExitDirection.NORTH] = (mask & EXIT_FLAGS[ExitDirection.NORTH]) != 0
	exits[ExitDirection.SOUTH] = (mask & EXIT_FLAGS[ExitDirection.SOUTH]) != 0
	exits[ExitDirection.EAST] = (mask & EXIT_FLAGS[ExitDirection.EAST]) != 0
	exits[ExitDirection.WEST] = (mask & EXIT_FLAGS[ExitDirection.WEST]) != 0
	update_exit_visuals()

var has_stairwell: bool = false

func set_has_stairwell(has_stairs: bool):
	has_stairwell = has_stairs
	stairs_icon.visible = has_stairs
