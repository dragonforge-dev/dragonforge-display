# Dragonforge Display
A video display autoload singleton to handle all video configuration for a game. (Monitors, not cameras.)
# Version 0.12
- For use with **Godot 4.4.1-stable** and later.
- **Requires** Dragonforge Disk version 0.3
# Installation Instructions
1. Copy the **dragonforge_display** folder from the **addons** folder into your project's **addons** folder.
2. If it does not exist already, copy the **dragonforge_disk** folder from the **addons** folder into your project's **addons** folder.
3. In your project go to **Project -> Project Settings...**
4. Select the **plugins** tab.
5. Check the **On checkbox** under **Enabled** for **Dragonforge Disk** (must be enabled **before** the Display plugin or you will get errors).
6. Check the **On checkbox** under **Enabled** for **Dragonforge Display**.
7. Press the **Close** button.
# Usage
Handles changing screen resolution, switching from windowed to fulls creen, scaling, and multiple monitors. Also allows the saving and loading of all these settings by default. In other words, calling these functions also sets the values and reloads them for the player on game start.
