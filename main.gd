extends Node2D

func _ready():
	print("Hello Dungeon!")
	
	var room = Node2D.new()
	room.set_script(load("res://scenes/Room.gd"))
	add_child(room)
	
	var floor_sprite = Sprite2D.new()
	floor_sprite.texture = load("res://assets/tiles/floor_tile.png")
	floor_sprite.position = Vector2(32, 32)
	room.add_child(floor_sprite)
	
	for exit_name in ["ExitN", "ExitS", "ExitE", "ExitW"]:
		var exit_node = ColorRect.new()
		exit_node.color = Color(0, 1, 0, 0.6)
		match(exit_name):
			"ExitN":
				exit_node.position = Vector2(32, 0)
				exit_node.margin_left = 32.0
				exit_node.margin_top = 0.0
				exit_node.margin_right = 64.0
				exit_node.margin_bottom = 16.0
			"ExitS":
				exit_node.position = Vector2(32, 64)
				exit_node.margin_left = 32.0
				exit_node.margin_top = 80.0
				exit_node.margin_right = 64.0
				exit_node.margin_bottom = 96.0
			"ExitE":
				exit_node.position = Vector2(64, 32)
				exit_node.margin_left = 80.0
				exit_node.margin_top = 32.0
				exit_node.margin_right = 96.0
				exit_node.margin_bottom = 64.0
			"ExitW":
				exit_node.position = Vector2(0, 32)
				exit_node.margin_left = 0.0
				exit_node.margin_top = 32.0
				exit_node.margin_right = 16.0
				exit_node.margin_bottom = 64.0
		exit_node.anchor_right = 0.5
		exit_node.anchor_bottom = 0.5
		exit_node.pivot = Vector2(0.5, 0.5)
		room.add_child(exit_node)
