extends Node

# ANTIALIASING
enum ANTI_ALIASING { DISABLED, FXAA, SMAA, MSAA, TAA }
enum GI { DISABLED, VOXELGI, SDFGI}

func _ready() -> void:
	load_settings()


## Loads user settings from config file.
func load_settings() -> void:
	## GAME
	#FOV
	var fov: float = SettingsFiles.get_setting("game", "fov")
	game_set_fov(fov)
	
	## DISPLAY
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
	
	## GRAPHICS
	# LOD THRESHOLD
	var threshold: float = SettingsFiles.get_setting("graphics", "lod_threshold")
	graphics_set_lod_threshold(threshold)
	

# FOV
func game_get_fov() -> float:
	var fov: float = SettingsFiles.get_setting("game", "fov")
	return fov


func game_set_fov(fov: float) -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera != null:
		camera.fov = fov
	SettingsFiles.apply_setting("game", "fov", fov)


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


## GRAPHICS
func graphics_get_lod_threshold() -> float:
	var threshold: float = SettingsFiles.get_setting("graphics", "lod_threshold")
	return threshold

func graphics_set_lod_threshold(threshold: float) -> void:
	get_tree().root.mesh_lod_threshold = threshold
	SettingsFiles.apply_setting("graphics", "lod_threshold", threshold)


# SCREEN-SPACE INDIRECT LIGHTING
func graphics_get_ssil() -> bool:
	var ssil: bool = SettingsFiles.get_setting("graphics", "ssil")
	return ssil

func graphics_set_ssil(toggle: bool) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.ssil_enabled = toggle
	SettingsFiles.apply_setting("graphics", "ssil", toggle)


func graphics_get_ssil_quality() -> RenderingServer.EnvironmentSSILQuality:
	var ssil_quality: RenderingServer.EnvironmentSSILQuality = SettingsFiles.get_setting("graphics", "ssil_quality")
	return ssil_quality

func graphics_set_ssil_quality(index: int) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		RenderingServer.environment_set_ssil_quality(index, true, 0.5, 4, 50, 300)
	SettingsFiles.apply_setting("graphics", "ssil_quality", index)


# SCREEN-SPACE REFLECTIONS
func graphics_get_ssr() -> bool:
	var ssr: bool = SettingsFiles.get_setting("graphics", "ssr")
	return ssr

func graphics_set_ssr(toggle: bool) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.set_ssr_enabled(toggle)
	SettingsFiles.apply_setting("graphics", "ssr", toggle)


func graphics_get_ssr_steps() -> int:
	var steps: int = SettingsFiles.get_setting("graphics", "ssr_steps")
	return steps

func graphics_set_ssr_steps(steps: int) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.ssr_max_steps = steps
	SettingsFiles.apply_setting("graphics", "ssr_steps", steps)


# SCREEN-SPACE AMBIENT OCCLUSION
func graphics_get_ssao() -> bool:
	var ssao: bool = SettingsFiles.get_setting("graphics", "ssao")
	return ssao

func graphics_set_ssao(toggle: bool) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.ssao_enabled = toggle
	SettingsFiles.apply_setting("graphics", "ssao", toggle)


func graphics_get_ssao_quality() -> RenderingServer.EnvironmentSSAOQuality:
	var ssao_quality: RenderingServer.EnvironmentSSAOQuality = SettingsFiles.get_setting("graphics", "ssao_quality")
	return ssao_quality

func graphics_set_ssao_quality(quality: RenderingServer.EnvironmentSSAOQuality) -> void:
	RenderingServer.environment_set_ssao_quality(quality, true, 0.5, 2, 50, 300)
	SettingsFiles.apply_setting("graphics", "ssao_quality", quality)

# GLOBAL ILLUMINATION
func graphics_get_gi() -> GI:
	var gi: GI = SettingsFiles.get_setting("graphics", "gi")
	return gi

func graphics_set_gi(gi: GI) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		reset_gi()
		match gi:
			GI.DISABLED:
				pass
			GI.VOXELGI:
				pass
			GI.SDFGI:
				environment.sdfgi_enabled = true
		
	SettingsFiles.apply_setting("graphics", "gi", gi)

func reset_gi() -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.sdfgi_enabled = false

func graphics_get_gi_resolution() -> bool:
	var gi_res: bool = SettingsFiles.get_setting("graphics", "gi_half_res")
	return gi_res

func graphics_set_gi_resolution(index: int) -> void:
	RenderingServer.gi_set_use_half_resolution(index == 1)
	SettingsFiles.apply_setting("graphics", "gi_half_res", index == 1)

# SDFGI
func graphics_get_sdfgi_cascades() -> int:
	var sdfgi_cascades: int = SettingsFiles.get_setting("graphics", "sdfgi_cascades")
	return sdfgi_cascades

func graphics_set_sdfgi_cascades(cascades: int) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.sdfgi_cascades = cascades
	SettingsFiles.apply_setting("graphics", "sdfgi_cascades", cascades)

func graphics_get_sdfgi_rays() -> RenderingServer.EnvironmentSDFGIRayCount:
	var rays: RenderingServer.EnvironmentSDFGIRayCount = SettingsFiles.get_setting("graphics", "sdfgi_rays")
	return rays

func graphics_set_sdfgi_rays(ray_count: RenderingServer.EnvironmentSDFGIRayCount) -> void:
	RenderingServer.environment_set_sdfgi_ray_count(ray_count)
	SettingsFiles.apply_setting("graphics", "sdfgi_rays", ray_count)

# VOXEL GI
func graphics_get_voxelgi_quality() -> RenderingServer.VoxelGIQuality:
	var voxelgi_quality: RenderingServer.VoxelGIQuality = SettingsFiles.get_setting("graphics", "voxelgi_quality")
	return voxelgi_quality

func graphics_set_voxelgi_quality(quality: RenderingServer.VoxelGIQuality) -> void:
	RenderingServer.voxel_gi_set_quality(quality)
	SettingsFiles.apply_setting("graphics", "voxelgi_quality", quality)


## Audio
func audio_get_volume(bus_index: int) -> float:
	match bus_index:
		0:
			return SettingsFiles.get_setting("audio", "master_volume")
		1:
			return SettingsFiles.get_setting("audio", "music_volume")
		2:
			return SettingsFiles.get_setting("audio", "effects_volume")
		3:
			return SettingsFiles.get_setting("audio", "ambient_volume")
		4:
			return SettingsFiles.get_setting("audio", "voice_volume")
		5:
			return SettingsFiles.get_setting("audio", "ui_volume")
	assert(false) # Unreachable
	return 1.0


func audio_set_volume(index: int, volume: float) -> void:
	var adjusted_volume: float = volume
	AudioServer.set_bus_volume_linear(index, adjusted_volume)
	match index:
		0:
			SettingsFiles.apply_setting("audio", "master_volume", adjusted_volume)
		1:
			SettingsFiles.apply_setting("audio", "music_volume", adjusted_volume)
		2:
			SettingsFiles.apply_setting("audio", "effects_volume", adjusted_volume)
		3:
			SettingsFiles.apply_setting("audio", "ambient_volume", adjusted_volume)
		4:
			SettingsFiles.apply_setting("audio", "voice_volume", adjusted_volume)
		5:
			SettingsFiles.apply_setting("audio", "ui_volume", adjusted_volume)
