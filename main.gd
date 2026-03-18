extends Node2D

func _ready():
	print("Hello Dungeon!")
	var room = preload("res://scenes/Room.tscn").instantiate()
	add_child(room)
