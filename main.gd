extends Node2D

func _ready():
	print("Hello Dungeon!")
	
	var dungeon_grid = load("res://scenes/DungeonGrid.gd").instantiate()
	add_child(dungeon_grid)
