extends Node


func _ready() -> void:
	load_settings()


## Loads user settings from config file.
func load_settings() -> void:
	var window_mode: DisplayServer.WindowMode = SettingsFiles.get_setting("display", "window_mode")
	display_set_window_mode(window_mode)
	
	var vsync_mode: DisplayServer.VSyncMode =  SettingsFiles.get_setting("display", "vsync_mode")
	display_set_vsync_mode(vsync_mode)
	
	var max_fps: int = SettingsFiles.get_setting("display", "max_fps")
	display_set_max_fps(max_fps)


# WINDOW MODE
func display_get_window_mode() -> int:
	var mode: DisplayServer.WindowMode = SettingsFiles.get_setting("display", "window_mode")
	return mode


func display_set_window_mode(window_mode: DisplayServer.WindowMode) -> void:
	DisplayServer.window_set_mode(window_mode)
	SettingsFiles.apply_setting("display", "window_mode", window_mode)

# VSYNC
func display_get_vsync_mode() -> int:
	var mode: int = SettingsFiles.get_setting("display", "vsync_mode")
	return mode


func display_set_vsync_mode(vsync_mode: DisplayServer.VSyncMode) -> void:
	DisplayServer.window_set_vsync_mode(vsync_mode)
	SettingsFiles.apply_setting("display", "vsync_mode", vsync_mode)


# FPS LIMIT
func display_get_max_fps() -> int:
	var max_fps: int = SettingsFiles.get_setting("display", "max_fps")
	return max_fps


func display_set_max_fps(max_fps: int) -> void:
	# The maximum number of frames per second that can be rendered.
	# A value of 0 means "no limit".
	Engine.max_fps = max_fps
	SettingsFiles.apply_setting("display", "max_fps", max_fps)
