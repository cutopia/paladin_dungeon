# Paladin Dungeon

A 2D auto-battler dungeon crawler where the player (as a deity) rotates grid-based rooms to control the paladin's path and delay dangerous encounters until she's strong enough.

## Development Status

### Phase 1: Core Systems ✅
- [x] Step 1: Project setup with floor tile display
- [x] Step 2: Room system with exit slots
- [x] Step 3: Grid-based dungeon layout (DungeonGrid.gd)
- [x] Step 4: Room rotation mechanics with input and visual feedback

### Phase 2: Gameplay Mechanics 🚧
- [ ] Step 5: Paladin auto-battler pathing
- [ ] Step 6: Monster placement and AI
- [ ] Step 7: Combat system
- [ ] Step 8: Staircase navigation between dungeon levels
- [ ] Step 9: Player progression/system upgrades

### Phase 3: Polish & Content 📋
- [ ] Step 10: Visual effects and animations
- [ ] Step 11: Sound and music integration
- [ ] Step 12: Final boss encounter

## Debug Scenario System

The game includes a powerful scenario system for debugging specific map layouts without having to manually rotate rooms.

### Usage

Run the game with the `--scenario` command line argument:

```bash
godot --scenario=scenarios/debug_room_rotation.json
```

Or using the alternative format:

```bash
godot --scenario scenarios/test_connectivity.json
```

### Scenario File Format

Scenario files are JSON documents that define the exact layout of a dungeon level.

```json
{
  "width": 3,
  "height": 3,
  "start_position": [0, 0],
  "rooms": [
    {"x": 0, "y": 0, "exits": ["N", "E"], "has_stairwell": false},
    {"x": 1, "y": 0, "exits": ["S", "W"], "has_stairwell": false},
    ...
  ]
}
```

#### Fields

| Field | Type | Description |
|-------|------|-------------|
| `width` | integer | Number of rooms horizontally (default: 3) |
| `height` | integer | Number of rooms vertically (default: 3) |
| `start_position` | array [x, y] | Starting position for the paladin (default: [0, 0]) |
| `rooms` | array | List of room definitions |

#### Room Definition

Each room in the `rooms` array has these fields:

| Field | Type | Description |
|-------|------|-------------|
| `x` | integer | X coordinate in the grid |
| `y` | integer | Y coordinate in the grid |
| `exits` | array of strings | Open exits: "N" (North), "S" (South), "E" (East), "W" (West) |
| `has_stairwell` | boolean | Whether this room contains a staircase to the next level |

### Example Scenarios

#### Simple 3x3 Grid with Connected Path
See `scenarios/debug_room_rotation.json`

#### Larger 4x3 Grid for Connectivity Testing
See `scenarios/test_connectivity.json`

## Building and Running

```bash
# Check script syntax
godot --check-only main.gd

# Run the game (default random dungeon)
godot

# Run with a specific scenario
godot --scenario=scenarios/debug_room_rotation.json
```

## Project Structure

```
paladin_dungeon/
├── scenes/
│   ├── DungeonGrid.gd      # Main dungeon grid controller
│   ├── Room.gd             # Individual room logic and rotation
│   ├── Monster.gd          # Monster AI and combat
│   ├── Paladin.gd          # Player character auto-battler
│   ├── ScenarioLoader.gd   # Debug scenario loader
│   └── *.tscn              # Godot scene files
├── scenarios/
│   ├── debug_room_rotation.json  # Example debug scenario
│   └── test_connectivity.json    # Connectivity test scenario
└── main.gd                 # Entry point

```

## Contributing

When adding new features:
1. Test with the default random dungeon first
2. Create specific scenarios to verify edge cases
3. Update this README with any new command-line options
