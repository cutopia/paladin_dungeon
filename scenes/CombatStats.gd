extends Node

# Shared combat statistics for entities (Paladin, Monster)
class_name CombatStats

@export var max_health: int = 100
@export var attack: int = 10
@export var experience: int = 0
@export var level: int = 1

var health: int

func _ready():
	health = max_health

func take_damage(amount: int) -> bool:
	health -= amount
	if health <= 0:
		return true  # Entity defeated
	return false

func heal(amount: int) -> void:
	health = min(health + amount, max_health)

func gain_experience(exp: int) -> void:
	experience += exp
	# Level up every 100 experience points (simple progression)
	if experience >= level * 100:
		level_up()

func level_up() -> void:
	level += 1
	max_health += 10
	health = max_health
	attack += 2
	print("Level up! Now level ", level, " with ", attack, " attack and ", max_health, " health")
