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

# UI Labels
var attack_label: Label = null
var health_label: Label = null

func _ready():
	update_monster_visuals()
	
	# Set proper size and center the monster in its Room (64x64 room, centered at 32,32)
	position = Vector2(0, 0)  # Center of room (room position is 32,32)
	
	# Create a small collision shape for the monster
	var collision_shape = CollisionShape2D.new()
	var capsule_shape = CapsuleShape2D.new()
	capsule_shape.radius = 16
	capsule_shape.height = 32
	collision_shape.shape = capsule_shape
	add_child(collision_shape)
	
	# Set collision layer/mask for monster
	collision_layer = 2  # Monster layer
	collision_mask = 1   # Collision with paladin
	
	create_health_attack_labels()

func create_health_attack_labels() -> void:
	# Create a container Control node for proper UI layout
	var container = Control.new()
	container.size = Vector2(64, 64)
	container.anchor_left = 0.5
	container.anchor_right = 0.5
	container.anchor_top = 0.5
	container.anchor_bottom = 0.5
	add_child(container)
	
	# Create attack label (top half of container)
	attack_label = Label.new()
	attack_label.anchor_left = 0.0
	attack_label.anchor_top = 0.0
	attack_label.size_flags_vertical = Control.SIZE_FILL
	container.add_child(attack_label)
	
	# Create health label (bottom half of container)
	health_label = Label.new()
	health_label.anchor_left = 0.0
	health_label.anchor_top = 0.5
	health_label.size_flags_vertical = Control.SIZE_FILL
	container.add_child(health_label)
	
	update_labels()

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
	
	update_labels()

func create_basic_monster_sprite():
	# Create a simple colored circle sprite programmatically
	var color_rect = ColorRect.new()
	color_rect.size = Vector2(64, 64)
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
	update_labels()
	return false

func update_labels() -> void:
	if attack_label:
		attack_label.text = "⚔️ %d" % damage
		attack_label.add_theme_font_size_override("font_size", 10)
	if health_label:
		health_label.text = "%d ❤️" % health
		health_label.add_theme_font_size_override("font_size", 10)

func _on_body_entered(body):
	if body.name == "Paladin":
		# Combat logic will be implemented in Step 7
		pass
