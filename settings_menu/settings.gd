extends Node

# ANTIALIASING
enum ANTI_ALIASING { DISABLED, FXAA, SMAA, MSAA, TAA }

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
	var anti_aliasing: ANTI_ALIASING = SettingsFiles.get_setting("display", "anti_aliasing")
	display_set_antialiasing(anti_aliasing)


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


# ANTI-ALISING
func display_get_antialiasing() -> int:
	var anti_aliasing: ANTI_ALIASING = SettingsFiles.get_setting("display", "anti_aliasing")
	return anti_aliasing


func display_set_antialiasing(mode: ANTI_ALIASING) -> void:
	var viewport: Viewport = get_viewport()

	disable_anti_aliasing(viewport)

	match mode:
		ANTI_ALIASING.FXAA:
			viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		ANTI_ALIASING.MSAA:
			var msaa_quality: int = Settings.display_get_msaa_quality()
			match msaa_quality:
				2:
					viewport.msaa_3d = Viewport.MSAA_2X
				4:
					viewport.msaa_3d = Viewport.MSAA_4X
				8:
					viewport.msaa_3d = Viewport.MSAA_8X
		ANTI_ALIASING.SMAA:
			viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_SMAA
		ANTI_ALIASING.TAA:
			viewport.use_taa = 1
	SettingsFiles.apply_setting("display", "anti_aliasing", mode)


func disable_anti_aliasing(viewport: Viewport) -> void:
	viewport.msaa_3d = Viewport.MSAA_DISABLED
	viewport.use_taa = false
	viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED


# MSAA
func display_get_msaa_quality() -> int:
	var msaa: int = SettingsFiles.get_setting("display", "msaa_quality")
	return msaa


func display_set_msaa_quality(index: int) -> void:
	var viewport: Viewport = get_viewport()
	match index:
		0:
			viewport.msaa_3d = Viewport.MSAA_2X
			SettingsFiles.apply_setting("display", "msaa_quality", 2)
		1:
			viewport.msaa_3d = Viewport.MSAA_4X
			SettingsFiles.apply_setting("display", "msaa_quality", 4)
		2:
			viewport.msaa_3d = Viewport.MSAA_8X
			SettingsFiles.apply_setting("display", "msaa_quality", 8)
