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

var exits = {
	ExitDirection.NORTH: false,
	ExitDirection.SOUTH: false,
	ExitDirection.EAST: false,
	ExitDirection.WEST: false
}

func _ready():
	generate_random_exits()
	update_exit_visuals()

func generate_random_exits():
	var num_exits = randi_range(2, 4)
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
	exit_n.visible = exits[ExitDirection.NORTH]
	exit_s.visible = exits[ExitDirection.SOUTH]
	exit_e.visible = exits[ExitDirection.EAST]
	exit_w.visible = exits[ExitDirection.WEST]

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

func get_exit_mask():
	var mask = 0
	if exits[ExitDirection.NORTH]: mask |= EXIT_FLAGS[ExitDirection.NORTH]
	if exits[ExitDirection.SOUTH]: mask |= EXIT_FLAGS[ExitDirection.SOUTH]
	if exits[ExitDirection.EAST]: mask |= EXIT_FLAGS[ExitDirection.EAST]
	if exits[ExitDirection.WEST]: mask |= EXIT_FLAGS[ExitDirection.WEST]
	return mask

func set_exit_mask(mask):
	exits[ExitDirection.NORTH] = (mask & EXIT_FLAGS[ExitDirection.NORTH]) != 0
	exits[ExitDirection.SOUTH] = (mask & EXIT_FLAGS[ExitDirection.SOUTH]) != 0
	exits[ExitDirection.EAST] = (mask & EXIT_FLAGS[ExitDirection.EAST]) != 0
	exits[ExitDirection.WEST] = (mask & EXIT_FLAGS[ExitDirection.WEST]) != 0
	update_exit_visuals()
