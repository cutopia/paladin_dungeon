extends Node2D

func _ready():
	var dungeon_grid = load("res://scenes/DungeonGrid.tscn").instantiate()
	add_child(dungeon_grid)
	
	var paladin = load("res://scenes/Paladin.tscn").instantiate()
	add_child(paladin)
