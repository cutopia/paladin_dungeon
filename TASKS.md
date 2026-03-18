# Task Tracking

## Current Phase: Phase 1 - Core Systems

### Step 2: Room system with exit slots (1-4 exits)
- [x] Create `Room.gd` script to manage room state and exits
- [x] Define 4 potential exit positions (North, South, East, West)
- [x] Implement exit configuration storage (bitmask or array)
- [x] Add visual representation of exits on room sprite
- [x] Test various exit configurations

### Step 3: Grid-based dungeon layout
- [ ] Create `DungeonGrid.gd` script to manage room grid
- [ ] Implement grid coordinate system (x, y)
- [ ] Handle neighbor relationships between rooms
- [ ] Add grid boundary checks

### Step 4: Room rotation mechanics
- [ ] Implement 90° clockwise rotation function
- [ ] Update exit positions after rotation
- [ ] Add player input to trigger rotation
- [ ] Visual feedback for rotation

### Step 5: Paladin auto-battler pathing
- [ ] Create `Paladin.gd` script
- [ ] Implement movement between connected rooms
- [ ] Pathfinding through available exits
- [ ] Detect and handle room entries/exits

## Future Steps
See AGENTS.md for complete roadmap.
