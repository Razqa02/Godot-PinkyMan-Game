# Project neq

A 2D platformer game built with **Godot 4.7.2** featuring smooth movement mechanics, collectibles, and enemy encounters across two levels.

---

## Table of Contents

- [Features](#features)
- [Game Flow](#game-flow)
- [Scene Structure](#scene-structure)
- [Player Controls](#player-controls)
- [Enemy Behavior](#enemy-behavior)
- [Script Overview](#script-overview)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)

---

## Features

- 🎮 **Smooth Platformer Movement** — Coyote time, jump buffering, and variable jump height
- 🍎 **Collectible System** — Apples scattered across levels that award points
- 🐌 **Snail Enemies** — Patrolling enemies that damage the player on contact
- 🏁 **Level Progression** — Finish line to advance between levels
- 📊 **Points Tracker** — Real-time UI displaying collected points
- ❤️ **Health System** — Player starts with 3 HP, dies and returns to main menu at 0

---

## Game Flow

1. **Main Menu** → Choose **LEVEL 1** or **LEVEL 2**
2. **Level 1** → Navigate platforms, collect apples, reach the finish line → advances to Level 2
3. **Level 2** → Navigate platforms, collect apples, avoid snails, reach the finish line → returns to Main Menu
4. **Game Over** → When player HP reaches 0, the game restarts at the main menu

---

## Player Controls

| Action | Key |
|--------|-----|
| Move Left | `A` / `Left Arrow` |
| Move Right | `D` / `Right Arrow` |
| Jump | `Space` / `W` / `Up Arrow` |

---

## Player Mechanics

- **Coyote Time** (0.09s) — Brief window to jump after leaving a platform edge
- **Jump Buffer** (0.09s) — Press jump slightly before landing and it still registers
- **Variable Jump Height** — Releasing the jump button early results in a shorter jump
- **Max Fall Speed** — Capped at 900 units/s for consistent falling
- **Animations** — Idle, Running, and Jumping (auto-switched based on state)

---

## Scene Structure

```
Main Menu (main_menu.tscn)
├── TextureRect (background)
├── TextureRect (title logo)
├── level1 (Button → loads level1.tscn)
└── level2 (Button → loads level2.tscn)

Level 1 (level1.tscn)
├── Node
│   ├── GameManager (game_manager.gd)
│   ├── SceneObjects
│   │   ├── TextureRect (background)
│   │   ├── TileMap (platforms & terrain)
│   │   ├── CharacterBody2D (Player)
│   │   │   ├── AnimatedSprite2D
│   │   │   ├── CollisionShape2D
│   │   │   └── Camera2D
│   │   ├── Collactables Group
│   │   │   └── Collectable × 15
│   │   ├── Finish (goes to level2.tscn)
│   │   └── UI (CanvasLayer → Panel → PointsLabel)
│   └── Panel2

Level 2 (level2.tscn)
├── Node (Level2Handler)
│   ├── GameManager (game_manager.gd)
│   ├── SceneObjects
│   │   ├── TextureRect (background)
│   │   ├── TileMap (platforms & terrain)
│   │   ├── CharacterBody2D (Player)
│   │   │   ├── AnimatedSprite2D
│   │   │   ├── CollisionShape2D
│   │   │   └── Camera2D
│   │   ├── Collactables Group
│   │   │   └── Collectable × 15
│   │   └── UI (CanvasLayer → Panel → PointsLabel)
│   ├── Collectables
│   ├── Enemies
│   │   ├── Snail (snail.tscn) × 3
│   │   └── (more enemies can be added)
│   ├── Finish (goes to main_menu.tscn)
│   └── Level2Handler (level_2_handler.gd)
```

---

## Enemy Behavior

**Snail** (`snail.gd`) — `Area2D` based enemy:
- Patrols back and forth horizontally at constant speed (100 units/s)
- Reverses direction every 2 seconds via `Timer` node
- Flips sprite horizontally when changing direction
- When player collides: emits `player_died` signal and calls `take_damage()` on the player

---

## Script Overview

| Script | Description |
|--------|-------------|
| `game_manager.gd` | Singleton manager that tracks points. Nodes subscribe to the `game_manager` group to access it. |
| `character.gd` | Player movement controller — implements coyote time, jump buffer, variable jump height, and health/damage system. |
| `snail.gd` | Snail enemy AI — patrols, reverses on timer, damages player on contact. |
| `collectable.gd` | Collectible item — awards a point to the GameManager and self-destructs on player pickup. |
| `finish.gd` | Finish line trigger — transitions to `target_level` scene when player touches it. |
| `main_menu.gd` | Main menu controller — handles level button presses and scene transitions. |
| `level_2_handler.gd` | Level 2 scene handler — connects all snail signals and manages enemy interactions. |
| `level_2.gd` | Level 2 Button script — simple placeholder for the level 2 menu button. |

---

## Project Structure

```
res://
├── Scenes/
│   ├── main_menu.tscn          # Main menu scene
│   ├── main_menu.gd            # Main menu controller
│   ├── level1.tscn             # Level 1 scene
│   ├── level2.tscn             # Level 2 scene
│   ├── level_2.gd              # Level 2 button script
│   ├── level_2_handler.gd      # Level 2 scene handler
│   ├── character.tscn          # Player character scene
│   ├── character.gd            # Player movement & health
│   ├── snail.tscn              # Snail enemy scene
│   ├── snail.gd                # Snail enemy AI
│   ├── collectable.tscn        # Collectible item scene
│   ├── collectable.gd          # Collectible logic
│   ├── finish.tscn             # Finish line scene
│   ├── finish.gd               # Finish line trigger
│   └── finish_fixed.gd         # Alternative finish line script
├── Image/
│   ├── Player/                 # Player sprite sheets (Idle, Run, Jump)
│   ├── Snail/                  # Snail walking sprite sheet
│   ├── Collect/                # Apple collectible sprite sheet
│   ├── Tilemap/                # Terrain tilemap texture
│   └── Baground/               # Background images
├── Sound/
│   └── jump.wav                # Jump sound effect
├── game_manager.gd             # GameManager singleton script
├── icon.svg                    # Project icon
└── project.godot               # Godot project configuration
```

---

## How to Run

1. Open the project in **Godot 4.7.2**
2. Set `res://Scenes/main_menu.tscn` as the main scene in **Project → Project Settings → Application → Config → Name**
3. Press **F5** or **F6** to run the game
4. Use the **Main Menu** to select Level 1 or Level 2

### Dependencies
- **Godot Engine 4.7.2-stable**
- **Jolt Physics** (configured in project.godot)
- **D3D12** rendering (Windows)

---

## Input Configuration

The project defines three input actions in **Project Settings → Input Map**:

| Action | Keys |
|--------|------|
| `jump` | Space, W, Up Arrow |
| `left` | A, Left Arrow |
| `right` | D, Right Arrow |

---

## Technical Notes

- **TileMap** uses `TileSetAtlasSource` with a 16×16 pixel tile texture, scaled 3× in-game
- **SpriteFrames** are defined as `AtlasTexture` sub-resources within each scene `.tscn` file
- **Physics** uses a collision layer system — the player's `collision_mask = 1` matches the tilemap's physics layer
- **Scene references** use string paths (`@export_file`) to avoid circular dependencies between levels

---

## License

Project neq — all rights reserved.
