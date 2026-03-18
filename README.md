# Paladin Dungeon - Step 1: Floor Tile Display

## Project Structure
```
paladin_dungeon/
├── project.godot          # Project configuration (main scene, settings)
├── main.gd               # Main scene script with floor tile sprite
├── scenes/
│   └── main.tscn         # Scene file containing Sprite2D with floor texture
├── assets/
│   └── tiles/
│       ├── floor_tile.png    # Generated floor tile texture (64x64)
│       └── floor_tile.png.import
└── .godot/               # Godot engine cache and settings
```

## How to Run

### Option 1: Using Godot Editor
Open the project in Godot 4.5:
```bash
godot4 --editor /path/to/paladin_dungeon/project.godot
```
Then press Play (F5) or click the Play button.

### Option 2: Command Line (Headless)
```bash
godot4 --headless /path/to/paladin_dungeon/project.godot
```

## What's Displayed

A single floor tile sprite centered on screen:
- **Texture**: 64x64 pixel gray tile with subtle pattern
- **Position**: Center of screen (400, 300)
- **Node Type**: Sprite2D
- **Scene Root**: Node2D

## Next Steps
- Add player movement controls
- Create dungeon floor grid
- Add walls and obstacles
