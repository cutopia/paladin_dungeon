extends Node2D

func _ready():
	# Check for --scenario command line argument
	var scenario_path = get_scenario_from_args()
	
	var dungeon_grid = load("res://scenes/DungeonGrid.tscn").instantiate()
	add_child(dungeon_grid)
	
	# Apply scenario if provided
	if scenario_path != "":
		var loader = preload("res://scenes/ScenarioLoader.gd").new()
		if loader.load_scenario(scenario_path):
			loader.apply_to_dungeon_grid(dungeon_grid)
	
	var paladin = load("res://scenes/Paladin.tscn").instantiate()
	add_child(paladin)

func get_scenario_from_args() -> String:
	# Get command line arguments
	var args = OS.get_cmdline_args()
	
	for arg in args:
		if arg.begins_with("--scenario="):
			return arg.trim_prefix("--scenario=")
		elif arg == "--scenario" and args.index_of(arg) < args.size() - 1:
			# Handle --scenario <path> format
			var idx = args.index_of(arg)
			return args[idx + 1]
	
	return ""
