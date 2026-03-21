# Paladin Dungeon

A 2D auto-battler dungeon crawler where the player (as a deity) rotates grid-based rooms to control the paladin's path and delay dangerous encounters until she's strong enough.

## Current Status

✅ **Step 1 Complete**: Project created, floor tile displays successfully  
✅ **Step 2 Complete**: Room system with exit slots implemented  
✅ **Step 3 Complete**: Grid-based dungeon layout with DungeonGrid.gd  
✅ **Step 4 Complete**: Room rotation mechanics with input and visual feedback  
✅ **Step 5 Complete**: Paladin auto-battler pathing with stairwell navigation  

## Project Structure

```
paladin_dungeon/
├── project.godot          # Project configuration (main scene, settings)
├── main.gd               # Main scene script that instantiates DungeonGrid and Paladin
├── scenes/
│   ├── main.tscn         # Scene file containing the root Node2D
│   ├── Room.gd           # Room logic: exits, rotation, visuals
│   ├── Room.tscn         # Room scene with exit sprites and stairs icon
│   ├── DungeonGrid.gd    # Grid management: spawns rooms, handles stairwells
│   ├── DungeonGrid.tscn  # Dungeon grid scene
│   ├── Paladin.gd        # Auto-battler movement between rooms
│   └── Paladin.tscn      # Paladin scene
├── assets/
│   └── tiles/
│       ├── floor_tile.png    # Generated floor tile texture (64x64)
│       ├── paladin.png       # Paladin sprite
│       └── stairs.png        # Stairwell icon
└── .godot/               # Godot engine cache and settings
```

## How to Run

### Using Godot Editor
```bash
godot --editor project.godot
```
Then press Play (F5) or click the Play button.

### Command Line (Headless)
```bash
godot --headless project.godot
```

## Game Features Implemented

### Room System
- Each room is a 64x64 grid cell with 1-4 exits (N/S/E/W)
- Exits can be on any combination of walls
- Rooms generate with random exit configurations
- Visual indicators show open vs blocked exits

### Room Rotation
- Click to rotate clockwise
- Shift-click to rotate counterclockwise
- Rotation changes exit positions relative to dungeon grid
- Scale animation provides visual feedback

### Dungeon Grid
- 3x3 grid layout (configurable)
- Automatic room spawning with random exits
- Stairwell placement in non-starting rooms
- Neighbor position calculations for movement

### Paladin Auto-Battler
- Moves automatically through connected rooms
- Chooses random valid exit when multiple options available
- Checks neighbor room has matching exit before moving
- Detects stairwells and triggers level generation
- Smooth tween animation between rooms
- Handles stairwell descent to next dungeon level

## Development Roadmap

### Phase 1: Core Systems ✅ COMPLETE
- [x] **Step 5**: Paladin auto-battler pathing
  - Create `Paladin.gd` script
  - Implement movement between connected rooms
  - Pathfinding through available exits
  - Detect and handle room entries/exits

### Phase 2: Gameplay Mechanics
- [ ] **Step 6**: Monster placement and AI
- [ ] **Step 7**: Combat system
- [ ] **Step 8**: Player progression/system upgrades

### Phase 3: Polish & Content
- [ ] **Step 9**: Visual effects and animations
- [ ] **Step 10**: Sound and music integration
- [ ] **Step 11**: Final boss encounter

## Game Mechanics

### Room System
- Each room is a grid cell with 1-4 exits (N/S/E/W)
- Exits can be on any combination of walls
- Rooms can be rotated 90° increments by player
- Rotation changes exit positions relative to dungeon grid

### Dungeon Generation
- Grid-based layout (configurable width/height)
- Each room generates with random exit configuration
- Path connectivity must be maintained (or player creates path via rotation)

### Paladin Auto-Battler
- Moves automatically through connected rooms
- Fights monsters in each room (not yet implemented)
- Gains experience/gold from victories (not yet implemented)
- Seeks staircases to descend deeper

### Player Intervention (Deity Role)
- Rotate rooms to control paladin's path
- Delay dangerous monster encounters
- Guide toward safer/explore routes

## Technical Notes
- Godot 4.5
- 2D top-down view
- Tile-based movement (64x64 tiles)
- Scene-based architecture
- Tween animations for smooth transitions
