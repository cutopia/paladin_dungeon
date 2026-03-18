extends Node2D

@onready var sprite = $FloorSprite

func _ready():
	print("Hello Dungeon!")
	print("Floor tile position: ", sprite.position)
