extends Area2D

enum MonsterType {
	SLIME = 0,
	KOBOLD = 1,
	SKELLY = 2,
	MIMIC = 3,
	DRAKE = 4
}

@export var monster_type: int = MonsterType.SLIME:
	set(value):
		monster_type = value
		update_monster_visuals()

# Combat stats - will be set by update_monster_visuals()
var damage: int = 3
var health: int = 15
var max_health: int = 15
var exp_reward: int = 8
var gold_reward: int = 4

# UI Labels
var attack_label: Label = null
var health_label: Label = null

func _ready():
	update_monster_visuals()
	
	# Position is set by Room.gd spawn_monster() to center the monster
	# Room sets position to Vector2(32, 32) which centers the monster in the 64x64 room
	
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
		MonsterType.SLIME:
			create_slime_sprite()
			damage = 3
			health = 15
			max_health = 15
			exp_reward = 8
			gold_reward = 4
		MonsterType.KOBOLD:
			create_kobold_sprite()
			damage = 6
			health = 25
			max_health = 25
			exp_reward = 15
			gold_reward = 10
		MonsterType.SKELLY:
			create_skelly_sprite()
			damage = 9
			health = 35
			max_health = 35
			exp_reward = 25
			gold_reward = 18
		MonsterType.MIMIC:
			create_mimic_sprite()
			damage = 12
			health = 50
			max_health = 50
			exp_reward = 40
			gold_reward = 35
		MonsterType.DRAKE:
			create_drake_sprite()
			damage = 18
			health = 90
			max_health = 90
			exp_reward = 75
			gold_reward = 60
	
	update_labels()

func create_slime_sprite():
	# Load and display the slime sprite
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/tiles/slime.png")
	sprite.position = Vector2(0, 0)
	add_child(sprite)

func create_kobold_sprite():
	# Load and display the kobold sprite
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/tiles/kobold.png")
	sprite.position = Vector2(0, 0)
	add_child(sprite)

func create_skelly_sprite():
	# Load and display the skelly sprite
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/tiles/skelly.png")
	sprite.position = Vector2(0, 0)
	add_child(sprite)

func create_mimic_sprite():
	# Load and display the mimic sprite
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/tiles/mimic.png")
	sprite.position = Vector2(0, 0)
	add_child(sprite)

func create_drake_sprite():
	# Load and display the drake sprite
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/tiles/drake.png")
	sprite.position = Vector2(0, 0)
	add_child(sprite)

func take_damage(amount: int) -> bool:
	health -= amount
	if health <= 0:
		return true  # Monster defeated
	update_labels()
	return false

func heal(amount: int) -> void:
	health = min(health + amount, max_health)
	update_labels()

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
