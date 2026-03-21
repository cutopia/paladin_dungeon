extends Area2D

enum MonsterType {
	BASIC = 0,
	TOUGH = 1,
	BOSS = 2
}

@export var monster_type: int = MonsterType.BASIC:
	set(value):
		monster_type = value
		update_monster_visuals()

# Combat stats
var damage: int = 5
var health: int = 20
var exp_reward: int = 10
var gold_reward: int = 5

func _ready():
	update_monster_visuals()
	
	# Set collision layer/mask for monster
	collision_layer = 2  # Monster layer
	collision_mask = 1   # Collision with paladin

func update_monster_visuals():
	match monster_type:
		MonsterType.BASIC:
			create_basic_monster_sprite()
			damage = 5
			health = 20
			exp_reward = 10
			gold_reward = 5
		MonsterType.TOUGH:
			create_tough_monster_sprite()
			damage = 10
			health = 40
			exp_reward = 20
			gold_reward = 15
		MonsterType.BOSS:
			create_boss_monster_sprite()
			damage = 15
			health = 80
			exp_reward = 50
			gold_reward = 30

func create_basic_monster_sprite():
	# Create a simple colored circle sprite programmatically
	var color_rect = ColorRect.new()
	color_rect.size = Vector2(32, 32)
	color_rect.color = Color(1.0, 0.5, 0.5)  # Light red
	add_child(color_rect)

func create_tough_monster_sprite():
	# Create a purple monster sprite
	var color_rect = ColorRect.new()
	color_rect.size = Vector2(32, 32)
	color_rect.color = Color(0.7, 0.3, 0.8)  # Purple
	add_child(color_rect)

func create_boss_monster_sprite():
	# Create a green boss sprite
	var color_rect = ColorRect.new()
	color_rect.size = Vector2(32, 32)
	color_rect.color = Color(0.5, 1.0, 0.5)  # Light green
	add_child(color_rect)

func take_damage(amount: int) -> bool:
	health -= amount
	if health <= 0:
		return true  # Monster defeated
	return false

func _on_body_entered(body):
	if body.name == "Paladin":
		# Combat logic will be implemented in Step 7
		pass
