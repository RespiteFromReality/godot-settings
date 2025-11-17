extends Node

const SETTINGS_FILE_PATH = "user://settings.ini"
const DEFAULT_SETTINGS_FILE_PATH = "user://settings_default.ini"

var user_config: ConfigFile


func _init() -> void:
	user_config = ConfigFile.new()

	# Create default settings file if first launch or they have been deleted.
	if FileAccess.file_exists(DEFAULT_SETTINGS_FILE_PATH) == false:
		create_defaults()

	# Load user settings if they exist, otherwise clone default settings and create a `settings.ini`.
	if FileAccess.file_exists(SETTINGS_FILE_PATH) == true:
		var err: Error = user_config.load(SETTINGS_FILE_PATH)
		if err != OK:
			printerr("Loading settings failed with: ", err)
	else:
		user_config.load(DEFAULT_SETTINGS_FILE_PATH)
		user_config.save(SETTINGS_FILE_PATH)


## File Functions
## Generates a ini file with default settings.
func create_defaults() -> void:
	var new_config := ConfigFile.new()

	new_config.set_value("config", "version", 1.0)
	
	new_config.set_value("game", "fov", 90)
	
	new_config.set_value("display", "window_mode", DisplayServer.WINDOW_MODE_WINDOWED)
	new_config.set_value("display", "vsync_mode", DisplayServer.VSYNC_DISABLED)
	new_config.set_value("display", "max_fps", 0)
	
	new_config.set_value("display", "anti_aliasing", Settings.ANTI_ALIASING.DISABLED)
	new_config.set_value("display", "msaa_quality", 4)

	new_config.set_value("display", "upscaler", Viewport.SCALING_3D_MODE_BILINEAR)
	new_config.set_value("display", "render_scale", 1.0)
	new_config.set_value("display", "fsr_quality", 0.67)
	new_config.set_value("display", "fsr_sharpness", 1.7)
	
	new_config.set_value("display", "brightness", 1.0)
	new_config.set_value("display", "contrast", 1.0)
	new_config.set_value("display", "saturation", 1.0)
	
	new_config.set_value("graphics", "lod_threshold", 2.0)
	new_config.set_value("graphics", "ssil", true)
	new_config.set_value("graphics", "ssil_quality", RenderingServer.ENV_SSIL_QUALITY_HIGH)
	
	new_config.set_value("graphics", "ssr", true)
	new_config.set_value("graphics", "ssr_steps", 32)
	
	new_config.set_value("graphics", "ssao", true)
	new_config.set_value("graphics", "ssao_quality", RenderingServer.ENV_SSAO_QUALITY_HIGH)
	
	new_config.set_value("graphics", "gi", Settings.GI.VOXELGI)
	new_config.set_value("graphics", "gi_half_res", true)
	new_config.set_value("graphics", "sdfgi_cascades", 4)
	new_config.set_value("graphics", "sdfgi_rays", RenderingServer.EnvironmentSDFGIRayCount.ENV_SDFGI_RAY_COUNT_16)
	new_config.set_value("graphics", "voxelgi_quality", RenderingServer.VOXEL_GI_QUALITY_LOW)
	
	new_config.set_value("graphics", "volumetric_fog", true)
	new_config.set_value("graphics", "volumetric_fog_filtering", true)
	
	new_config.set_value("audio", "master_volume", 1.0)
	new_config.set_value("audio", "music_volume", 1.0)
	new_config.set_value("audio", "effects_volume", 1.0)
	new_config.set_value("audio", "ambient_volume", 1.0)
	new_config.set_value("audio", "voice_volume", 1.0)
	new_config.set_value("audio", "ui_volume", 1.0)
	
	new_config.save(DEFAULT_SETTINGS_FILE_PATH)


func apply_setting(section: String, key: String, value: Variant) -> void:
	user_config.set_value(section, key, value)
	user_config.save(SETTINGS_FILE_PATH)


func get_setting(section: String, key: String) -> Variant:
	if user_config.has_section(section):
		var value: Variant = user_config.get_value(section, key)
		return value
	else:
		return -1


func save_settings() -> Error:
	var err: Error = user_config.save(SETTINGS_FILE_PATH)
	if err != OK:
		printerr("Saving settings failed with: ", err)

	return err



# Creates or loads `default_settings.ini` and overrides `settings.ini` with default values.
func restore_default_settings() -> void:
	var default_config := ConfigFile.new()

	# Load default_settings.ini or create it if it missing.
	if FileAccess.file_exists(DEFAULT_SETTINGS_FILE_PATH) == false:
		create_defaults()

	default_config.load(DEFAULT_SETTINGS_FILE_PATH)
	default_config.save(SETTINGS_FILE_PATH)
