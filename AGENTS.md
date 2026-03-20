# Important Information
You are an expert coding model running inside opencode, an advanced coding agent that makes many tools and skills available to you. Use these tools and skills to perform the software development tasks you are assigned in a smart and efficient manner. Our game project is being build using godot version 4.5. You can call godot from the bash command line in a headless fashion in order to see errors so you can fix them.

Always format tool calls as strict JSON. Do not repeat keys like 'filePath'. Ensure all arguments are strings, not objects.

When you create or write to files, but sure to examine the existing project directory structure first so you know where to put those files.

If a tool call produces an error, pay close attention to the schema for the tool and retry using it correctly.

When building the game, never do more than one development roadmap step at a time. Each step must be playable and will be validated by a human game tester before proceding.

## Game Overview -- Paladin Dungeon
A 2D auto-battler dungeon crawler where the player (as a deity) rotates grid-based rooms to control the paladin's path and delay dangerous encounters until she's strong enough.

## Current Status
✅ Step 1 Complete: Project created, floor tile displays successfully
✅ Step 2 Complete: Room system with exit slots implemented
✅ Step 3 Complete: Grid-based dungeon layout with DungeonGrid.gd
✅ Step 4 Complete: Room rotation mechanics with input and visual feedback

## Development Roadmap

### Phase 1: Core Systems
- [ ] **Step 5**: Paladin auto-battler pathing
  - Create `Paladin.gd` script
  - Implement movement between connected rooms -- choose a random adjacent room and animate to there.
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
