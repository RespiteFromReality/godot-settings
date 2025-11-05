extends Node


func _ready() -> void:
	load_settings()


## Loads user settings from config file.
func load_settings() -> void:
	var window_mode: DisplayServer.WindowMode = SettingsFiles.get_setting("display", "window_mode")
	display_set_window_mode(window_mode)
	
# WINDOW MODE
func display_get_window_mode() -> int:
	var mode: DisplayServer.WindowMode = SettingsFiles.get_setting("display", "window_mode")
	return mode


func display_set_window_mode(window_mode: DisplayServer.WindowMode) -> void:
	DisplayServer.window_set_mode(window_mode)
	SettingsFiles.apply_setting("display", "window_mode", window_mode)
