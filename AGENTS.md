# Paladin Dungeon - Project Documentation

Important agent instruction:
Always format tool calls as strict JSON. Do not repeat keys like 'filePath'. Ensure all arguments are strings, not objects.

We practice iterative development where each system or feature that is developed should result in the game being runnable to easily demo to stakeholders. A feature or system is complete when the game runs without error and the feature or system's functionality can be clearly demonstrated or is visibly apparent when the game is run.

## Game Overview
A 2D auto-battler dungeon crawler where the player (as a deity) rotates grid-based rooms to control the paladin's path and delay dangerous encounters until she's strong enough.

## Current Status
✅ Step 1 Complete: Project created, floor tile displays successfully

## Development Roadmap

### Phase 1: Core Systems
- [ ] **Step 2**: Room system with exit slots (1-4 exits)
  - Create `Room.gd` script to manage room state and exits
  - Define 4 potential exit positions (North, South, East, West)
  - Implement exit configuration storage (bitmask or array)
  - Add visual representation of exits on room sprite
  - Test various exit configurations

- [ ] **Step 3**: Grid-based dungeon layout
  - Create `DungeonGrid.gd` script to manage room grid
  - Implement grid coordinate system (x, y)
  - Handle neighbor relationships between rooms
  - Add grid boundary checks

- [ ] **Step 4**: Room rotation mechanics
  - Implement 90° clockwise rotation function
  - Update exit positions after rotation
  - Add player input to trigger rotation
  - Visual feedback for rotation

- [ ] **Step 5**: Paladin auto-battler pathing
  - Create `Paladin.gd` script
  - Implement movement between connected rooms
  - Pathfinding through available exits
  - Detect and handle room entries/exits

### Phase 2: Gameplay Mechanics
- [ ] **Step 6**: Monster placement and AI
- [ ] **Step 7**: Combat system
- [ ] **Step 8**: Staircase navigation between dungeon levels
- [ ] **Step 9**: Player progression/system upgrades

### Phase 3: Polish & Content
- [ ] **Step 10**: Visual effects and animations
- [ ] **Step 11**: Sound and music integration
- [ ] **Step 12**: Final boss encounter

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
- Fights monsters in each room
- Gains experience/gold from victories
- Seeks staircases to descend deeper

### Player Intervention (Deity Role)
- Rotate rooms to control paladin's path
- Delay dangerous monster encounters
- Guide toward safer/explore routes

## Technical Notes
- Godot 4.5
- 2D top-down view
- Tile-based movement
- Scene-based architecture
