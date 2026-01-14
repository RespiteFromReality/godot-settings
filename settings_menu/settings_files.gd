extends Node

const SETTINGS_FILE_PATH = "user://settings.ini"

var user_config: ConfigFile

func _init() -> void:
	if FileAccess.file_exists(SETTINGS_FILE_PATH) == false:
		user_config = create_default()
		user_config.save(SETTINGS_FILE_PATH)
	else:
		user_config = ConfigFile.new()
		var err: Error = user_config.load(SETTINGS_FILE_PATH)
		assert(err == OK) # Just panic in debug.
		if err != OK:
			printerr("Failed to load config file with error: ", err)
			printerr(err)
			user_config = create_default()


## File Functions
## Generates a ConfigFile with default settings.
func create_default() -> ConfigFile:
	var default_config: ConfigFile = ConfigFile.new()
	
	default_config.set_value("config", "version", 1.0)
	
	default_config.set_value("game", "fov", 90)
	
	default_config.set_value("display", "window_mode", DisplayServer.WINDOW_MODE_WINDOWED)
	default_config.set_value("display", "vsync_mode", DisplayServer.VSYNC_DISABLED)
	default_config.set_value("display", "max_fps", 0)
	
	default_config.set_value("display", "anti_aliasing", Settings.ANTI_ALIASING.DISABLED)
	default_config.set_value("display", "msaa_quality", 4)

	default_config.set_value("display", "upscaler", Viewport.SCALING_3D_MODE_BILINEAR)
	default_config.set_value("display", "render_scale", 1.0)
	default_config.set_value("display", "fsr_quality", 0.67)
	default_config.set_value("display", "fsr_sharpness", 1.7)
	
	default_config.set_value("display", "brightness", 1.0)
	default_config.set_value("display", "contrast", 1.0)
	default_config.set_value("display", "saturation", 1.0)
	
	default_config.set_value("rendering", "lod_threshold", 2.0)
	default_config.set_value("rendering", "ssil", true)
	default_config.set_value("rendering", "ssil_quality", RenderingServer.ENV_SSIL_QUALITY_HIGH)
	
	default_config.set_value("rendering", "ssr", true)
	default_config.set_value("rendering", "ssr_steps", 32)
	
	default_config.set_value("rendering", "ssao", true)
	default_config.set_value("rendering", "ssao_quality", RenderingServer.ENV_SSAO_QUALITY_HIGH)
	
	default_config.set_value("rendering", "gi", Settings.GI.VOXELGI)
	default_config.set_value("rendering", "gi_half_res", true)
	default_config.set_value("rendering", "sdfgi_cascades", 4)
	default_config.set_value("rendering", "sdfgi_rays", RenderingServer.EnvironmentSDFGIRayCount.ENV_SDFGI_RAY_COUNT_16)
	default_config.set_value("rendering", "voxelgi_quality", RenderingServer.VOXEL_GI_QUALITY_LOW)
	
	default_config.set_value("rendering", "volumetric_fog", true)
	default_config.set_value("rendering", "volumetric_fog_filtering", true)
	
	default_config.set_value("rendering", "shadow_resolution_positional", 1024)
	default_config.set_value("rendering", "shadow_resolution_directional", 1024)
	default_config.set_value("rendering", "shadow_filtering_positional", RenderingServer.ShadowQuality.SHADOW_QUALITY_SOFT_MEDIUM)
	default_config.set_value("rendering", "shadow_filtering_directional", RenderingServer.ShadowQuality.SHADOW_QUALITY_SOFT_MEDIUM)
	
	default_config.set_value("rendering", "bloom", true)
	default_config.set_value("rendering", "bloom_bicubic", true)
	
	default_config.set_value("audio", "master_volume", 1.0)
	default_config.set_value("audio", "music_volume", 1.0)
	default_config.set_value("audio", "effects_volume", 1.0)
	default_config.set_value("audio", "ambient_volume", 1.0)
	default_config.set_value("audio", "voice_volume", 1.0)
	default_config.set_value("audio", "ui_volume", 1.0)
	
	default_config.set_value("ui", "scale", 1.0)
	
	return default_config


func apply_setting(section: String, key: String, value: Variant) -> void:
	user_config.set_value(section, key, value)
	save_config(user_config)


func get_setting(section: String, key: String) -> Variant:
	if user_config.has_section(section):
		var value: Variant = user_config.get_value(section, key)
		return value
	else:
		assert(false) # Just panic on this in debug.
		return -1


func save_config(config: ConfigFile) -> Error:
	var err: Error = config.save(SETTINGS_FILE_PATH)
	if err != OK:
		assert(false) # Just panic in debug.
		printerr("Saving settings failed with: ", err)

	return err


func restore_default_settings() -> void:
	user_config = create_default()
	save_config(user_config)
