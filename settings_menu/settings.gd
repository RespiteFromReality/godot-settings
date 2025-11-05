extends Node

# ANTIALIASING
enum ANTI_ALIASING { DISABLED, FXAA, SMAA, MSAA, TAA }

func _ready() -> void:
	load_settings()


## Loads user settings from config file.
func load_settings() -> void:
	# WINDOW MODE
	var window_mode: DisplayServer.WindowMode = SettingsFiles.get_setting("display", "window_mode")
	display_set_window_mode(window_mode)
	
	# VSYNC
	var vsync_mode: DisplayServer.VSyncMode =  SettingsFiles.get_setting("display", "vsync_mode")
	display_set_vsync_mode(vsync_mode)
	
	# FPS LIMIT
	var max_fps: int = SettingsFiles.get_setting("display", "max_fps")
	display_set_max_fps(max_fps)
	
	# ANTI-ALIASING
	var anti_aliasing: ANTI_ALIASING = SettingsFiles.get_setting("display", "anti_aliasing")
	display_set_antialiasing(anti_aliasing)
	
	# UPSCALER
	var upscaler: int = SettingsFiles.get_setting("display", "upscaler")
	display_set_upscaler(upscaler)
	var render_scale: float = SettingsFiles.get_setting('display', "render_scale")
	display_set_render_scale(render_scale)
	
	# FSR
	var sharpness: float = SettingsFiles.get_setting("display", "fsr_sharpness")
	var quality: float = SettingsFiles.get_setting("display", "fsr_quality")
	display_set_fsr_sharpness(sharpness)
	display_set_fsr_quality(quality)
	
	# ADJUSTMENTS
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.adjustment_enabled = true
		var brightness: float = SettingsFiles.get_setting("display", "brightness")
		var contrast: float = SettingsFiles.get_setting("display", "contrast")
		var saturation: float = SettingsFiles.get_setting("display", "saturation")
		display_set_brightness(brightness)
		display_set_contrast(contrast)
		display_set_saturation(saturation)

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


# UPSCALING
func display_get_upscaler() -> Viewport.Scaling3DMode:
	var upscaler: Viewport.Scaling3DMode = SettingsFiles.get_setting("display", "upscaler")
	return upscaler


func display_set_upscaler(mode: Viewport.Scaling3DMode) -> void:
	var viewport: Viewport = get_viewport()
	match mode:
		Viewport.SCALING_3D_MODE_BILINEAR:
			viewport.scaling_3d_mode = mode
		Viewport.SCALING_3D_MODE_FSR2:
			viewport.scaling_3d_mode = mode
			var quality: float = display_get_fsr_quality()
			var sharpness: float = display_get_fsr_sharpness()
			viewport.scaling_3d_scale = quality
			viewport.fsr_sharpness = sharpness
	SettingsFiles.apply_setting("display", "upscaler", mode)


# FSR
func display_get_fsr_quality() -> float:
	var quality: float = SettingsFiles.get_setting("display", "fsr_quality")
	return quality


func display_set_fsr_quality(quality: float) -> void:
	var viewport: Viewport = get_viewport()
	viewport.scaling_3d_scale = quality
	SettingsFiles.apply_setting("display", "fsr_quality", quality)


func display_get_fsr_sharpness() -> float:
	var sharpness: float = SettingsFiles.get_setting("display", "fsr_sharpness")
	return sharpness


## FSR Sharpness is a range of 0.0 to 2.0, with 0.0 being sharpest, 2.0 being least sharp.
func display_set_fsr_sharpness(sharpness: float) -> void:
	var viewport: Viewport = get_viewport()
	viewport.fsr_sharpness = sharpness
	SettingsFiles.apply_setting("display", "fsr_sharpness", sharpness)


# RENDER SCALE
func display_get_render_scale() -> float:
	var scale: float = SettingsFiles.get_setting("display", "render_scale")
	return scale


func display_set_render_scale(scale: float) -> void:
	var viewport: Viewport = get_viewport()
	viewport.scaling_3d_scale = scale
	SettingsFiles.apply_setting("display", "render_scale", scale)

# ADJUSTMENTS

# BRIGHTNESS
func display_get_brightness() -> float:
	var brightness: float = SettingsFiles.get_setting("display", "brightness")
	return brightness

func display_set_brightness(brightness: float) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.set_adjustment_brightness(brightness)
	SettingsFiles.apply_setting("display", "brightness", brightness)


# CONTRAST
func display_get_contrast() -> float:
	var contrast: float = SettingsFiles.get_setting("display", "contrast")
	return contrast

func display_set_contrast(contrast: float) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.set_adjustment_contrast(contrast)
	SettingsFiles.apply_setting("display", "contrast", contrast)


# SATURATION
func display_get_saturation() -> float:
	var saturation: float = SettingsFiles.get_setting("display", "saturation")
	return saturation

func display_set_saturation(saturation: float) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.set_adjustment_saturation(saturation)
	SettingsFiles.apply_setting("display", "saturation", saturation)

