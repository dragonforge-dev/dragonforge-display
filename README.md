[![Static Badge](https://img.shields.io/badge/Godot%20Engine-4.5.stable-blue?style=plastic&logo=godotengine)](https://godotengine.org/)
[![License](https://img.shields.io/github/license/dragonforge-dev/dragonforge-display?logo=mit)](https://github.com/dragonforge-dev/dragonforge-display/blob/main/LICENSE)
[![GitHub release badge](https://badgen.net/github/release/dragonforge-dev/dragonforge-display/latest)](https://github.com/dragonforge-dev/dragonforge-display/releases/latest)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/dragonforge-dev/dragonforge-display)](https://img.shields.io/github/languages/code-size/dragonforge-dev/dragonforge-display)

# Dragonforge Display <img src="/addons/dragonforge_display/assets/textures/icons/monitor.svg" width="32" alt="Display Icon"/>
A video display autoload singleton to handle all video configuration for a game. (Monitors, not cameras.)
# Version 0.14.2
For use with **Godot 4.5.stable** and later.
## Dependencies
The following dependencies are included in the addons folder and are required for the template to function.
- [Dragonforge Disk (Save/Load) 0.6](https://github.com/dragonforge-dev/dragonforge-disk)
- [Dragonforge User Interface 0.1.3](https://github.com/dragonforge-dev/dragonforge-user-interface)
# Installation Instructions
1. Copy the `dragonforge_display` folder from the `addons` folder into your project's `addons` folder.
2. If it does not exist already, copy the `dragonforge_disk` folder from the `addons` folder into your project's `addons` folder.
3. If it does not exist already, copy the `dragonforge_user_interface` folder from the `addons` folder into your project's `addons` folder.
4. In your project go to **Project -> Project Settings...**
5. Select the **plugins** tab.
6. Check the **On checkbox** under **Enabled** for **Dragonforge Disk** (must be enabled **before** the Display plugin or you will get errors).
7. Check the **On checkbox** under **Enabled** for **Dragonforge Display**.
8. Check the **On checkbox** under **Enabled** for **Dragonforge User Interface**.
9. Press the **Close** button.

# Usage Instructions
Handles changing screen resolution, switching from windowed to full screen, scaling, and multiple monitors. Also allows the saving and loading of all these settings by default. In other words, calling these functions also sets the values and reloads them for the player on game start.

## Display Screen
In `res://addons/dragonforge_display/ui/screens/display.tscn` there is a default screen for setting all available display options. Using `res://test/test.tscn`, you can test all these settings out. Pressing the Run Prjoject (F5) button will also allow you to test everything.

## Choosing Allowed Resolutions
If you want to change what resolutions are available to the player, edit the `RESOLUTIONS` constant in `display.gd`. current value are:
```
const RESOLUTIONS: Array[Vector2i] = [
	Vector2i(3840, 2160),
	Vector2i(2560, 1080),
	Vector2i(1920, 1080),
	Vector2i(1536, 864),
	Vector2i(1366, 768),
	Vector2i(1280, 720),
	Vector2i(1440, 900),
	Vector2i(1600, 900),
	Vector2i(1152, 648),
	Vector2i(1024, 600),
	Vector2i(800, 600),
	Vector2i(630, 500), # Added for Itch.io cover image screenshots
]
```

# Class Descriptions
## Display (Autoload) <img src="/addons/dragonforge_display/assets/textures/icons/monitor.svg" width="32" alt="Display Icon"/>
### Signals
- `fullscreen(fullscreen_on: bool)` Sent when fullscreen is toggled on/off.
- `video_scale_changed(new_value: float)` Sent when the 3D video scale is changed. (Only possible in fullscreen.)
- `window_moved_to_monitor(new_monitor_id: int)` Sent when a new monitor is selected. (Note dragging the window to a new monitor only has an effect is the size of the window is also changed. Otherwise the value must be set through `select_monitor(monitor_number: int)` to send this signal.
- `resolution_changed(new_resolution: Vector2i)` Sent when the screen resolution changes. (But not if it changes because fullscreen was toggled.)
### Constants
- `RESOLUTIONS` An array storing all the resolutions the player can choose from when hooked up to a UI.
### Public Functions
- `full_screen(on: bool) -> void` Turn fullscreen on/off.
- `is_fullscreen() -> bool` Returns whether fullscreen is currently on.
- `set_resolution(resolution: Vector2i) -> void` Set monitor resolution.
- `select_monitor(monitor_number: int) -> void` Move the game to the passed monitor.
- `scale_zoom(zoom: float) -> void` Change the 3D scale zoom. (Only has an effect in fullscreen mode.)
- `get_scaling() -> float` Get 3D scaling value. (Only has an effect in fullscreen mode.)

# Localization
This project's UI has been created to work with localization. You can easily use localization by using the [Dragonforge Localization](https://github.com/dragonforge-dev/dragonforge-localization) plugin. The following labels exist and should be given translations:

- DISPLAY_SETTINGS
- MONITOR
- FULLSCREEN
- RESOLUTION
- ZOOM_SCALE
- BACK
