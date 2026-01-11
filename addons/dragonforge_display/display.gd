@icon("res://addons/dragonforge_display/assets/textures/icons/monitor.svg")
extends Node

signal fullscreen(fullscreen_on: bool)
signal video_scale_changed(new_value: float)
signal window_moved_to_monitor(new_monitor_id: int)
signal resolution_changed(new_resolution: Vector2i)

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

@export var debug := false

var active_monitor: int:
	set(value):
		active_monitor = value
		if active_monitor != null:
			window_moved_to_monitor.emit(active_monitor)
			Disk.save_setting(active_monitor, "Monitor Number")


func _ready() -> void:
	# Monitor Selection
	var returned_value = Disk.load_setting("Monitor Number")
	if debug: print_rich("[color=green]Loaded Monitor Number:[/color] %s" % [returned_value])
	if returned_value:
		if returned_value != DisplayServer.window_get_current_screen():
			active_monitor = returned_value
			select_monitor(active_monitor)
	else:
		active_monitor = DisplayServer.window_get_current_screen()
	
	# Window Mode
	var window_mode = Disk.load_setting("window_mode")
	if debug: print_rich("[color=green]Loaded Window Mode:[/color] %s" % [window_mode])
	if window_mode:
		select_window_mode(window_mode)
	
	# Resolution Functionality
	var current_resolution = Disk.load_setting("Current Resolution")
	if debug: print_rich("[color=green]Loaded Resolution:[/color] %s" % [current_resolution])
	if current_resolution is Vector2i:
		set_resolution(current_resolution)
	get_viewport().size_changed.connect(_on_window_size_changed)
	
	# Scale Zoom
	if is_fullscreen():
		var zoom = Disk.load_setting("Scale Zoom")
		if zoom:
			scale_zoom(zoom)


## Allows for non-standard window sizes (i.e. if the user drags the window size
## around). Also tracks changes to the monitor the screen is on - but only if
## the size of the window is changed.
func _on_window_size_changed() -> void:
	var monitor_resolution = DisplayServer.screen_get_size()
	if debug: print_rich("[color=red]Monitor Size:[/color] %s, [color=yellow]Window Size:[/color] %s" % [monitor_resolution, get_window().size])
	# Stop infinite recursion
	if monitor_resolution == get_window().get_size_with_decorations():
		return
	if monitor_resolution.y > monitor_resolution.x:
		set_resolution(Vector2i(get_window().size.y, get_window().size.x), true)
	else:
		set_resolution(get_window().size, true)
	# See if the monitor has changed.
	if DisplayServer.window_get_current_screen() != active_monitor:
		active_monitor = DisplayServer.window_get_current_screen()

#
### Turn fullscreen on/off.
### @deprecated: Changed to select_window_mode()
#func full_screen(on: bool) -> void:
	#if on:
		#get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	#else:
		#var screen = DisplayServer.window_get_current_screen()
		#get_window().mode = Window.MODE_WINDOWED
		#DisplayServer.window_set_current_screen(screen) # We have to switch back to the screen we were just on (may be a bug)
		#get_window().move_to_center()
	#
	#fullscreen.emit(on)
	#resolution_changed.emit(get_window().size)
	#
	#Disk.save_setting(on, "Fullscreen")


func select_window_mode(window_mode: Window.Mode) -> void:
	if debug: print_rich("[color=red]Old Window Mode:[/color] %s, [color=skyblue]New Window Mode:[/color] %s" % [get_window().mode, window_mode])
	get_window().mode = window_mode
	ProjectSettings.set_setting("display/window/size/mode", window_mode)
	if window_mode == Window.MODE_EXCLUSIVE_FULLSCREEN or window_mode == Window.MODE_FULLSCREEN:
		fullscreen.emit(true)
	else:
		fullscreen.emit(false)
	resolution_changed.emit(get_window().size)
	
	# Change it in the project settings so it starts up correctly in the editor
	#var editor_settings = EditorInterface.get_editor_settings()
	#editor_settings.set_setting("run/window_placement/rect", window_mode)
	
	#Save it
	Disk.save_setting(window_mode, "window_mode")


## Returns whether fullscreen is currently on.
func is_fullscreen() -> bool:
	return get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN or get_window().mode == Window.MODE_FULLSCREEN


## Set monitor resolution. If `silent` is `true`, [signal resolution_changed]
## will not be emitted. (This is to prevent recursion.)
func set_resolution(resolution: Vector2i, silent = false) -> void:
	if debug: print_rich("[color=red]Old Resolution:[/color] %s, [color=yellow]Old Resolution with Decorations:[/color] %s, [color=skyblue]New Resolution:[/color] %s" % [get_window().size, get_window().get_size_with_decorations(), resolution])
	get_window().size = resolution
	
	get_window().move_to_center()
	Disk.save_setting(get_window().size, "Current Resolution")
	if not silent:
		resolution_changed.emit(resolution)


## Move the game to the passed monitor. ???????????(Only has an effect in fullscreen mode.)
func select_monitor(monitor_number: int) -> void:
	if debug: print_rich("[color=red]Old Monitor:[/color] %s, [color=skyblue]New Monitor:[/color] %s" % [DisplayServer.window_get_current_screen(), monitor_number])
	DisplayServer.window_set_current_screen(monitor_number)
	get_window().move_to_center()
	# Edit the project settings so the game starts on the selected screen in the future.
	if monitor_number == 1:
		if ProjectSettings.get_setting("display/window/size/initial_position_type") == 2:
			ProjectSettings.set_setting("display/window/size/initial_position_type", 0)
	else:
		if ProjectSettings.get_setting("display/window/size/initial_position_type") != 2:
			ProjectSettings.set_setting("display/window/size/initial_position_type", 2)
	ProjectSettings.set_setting("display/window/size/initial_screen", monitor_number)
		
	
	Disk.save_setting(monitor_number, "Monitor Number")


## Change the 3D scale zoom. (Only has an effect in fullscreen mode.)
func scale_zoom(zoom: float) -> void:
	get_viewport().set_scaling_3d_scale(zoom)
	video_scale_changed.emit(zoom)
	Disk.save_setting(zoom, "Scale Zoom")


## Get 3D scaling value.
func get_scaling() -> float:
	return get_viewport().scaling_3d_scale
