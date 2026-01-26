extends Node

# ANTIALIASING
enum ANTI_ALIASING { DISABLED, FXAA, SMAA, MSAA, TAA }
enum MSAA { x2, x4, x8 }
enum GI { DISABLED, VOXELGI, SDFGI}
enum SHADOW_RESOLUTION { x512, x1024, x2048, x4096, x8192 }

signal reload_settings

var viewport_start_size := Vector2(
	ProjectSettings.get_setting(&"display/window/size/viewport_width"),
	ProjectSettings.get_setting(&"display/window/size/viewport_height")
)

func _ready() -> void:
	load_settings()


func restore_defaults() -> void:
	SettingsFiles.restore_default_settings()
	load_settings()
	reload_settings.emit()


## Loads user settings from config file.
func load_settings() -> void:
	## GAME
	#FOV
	var fov: float = SettingsFiles.get_setting("game", "fov")
	set_fov(fov)
	
	## DISPLAY
	# WINDOW MODE
	var window_mode: DisplayServer.WindowMode = SettingsFiles.get_setting("display", "window_mode")
	set_window_mode(window_mode)
	
	# VSYNC
	var vsync_mode: DisplayServer.VSyncMode =  SettingsFiles.get_setting("display", "vsync_mode")
	set_vsync_mode(vsync_mode)
	
	# FPS LIMIT
	var max_fps: int = SettingsFiles.get_setting("display", "max_fps")
	set_max_fps(max_fps)
	
	# ANTI-ALIASING
	var anti_aliasing: ANTI_ALIASING = SettingsFiles.get_setting("display", "anti_aliasing")
	set_antialiasing(anti_aliasing)
	
	# UPSCALER
	var upscaler: int = SettingsFiles.get_setting("display", "upscaler")
	set_upscaler(upscaler)
	
	if upscaler == 0:
		# RENDER SCALE
		var render_scale: float = SettingsFiles.get_setting('display', "render_scale")
		set_render_scale(render_scale)
	else:
		# FSR
		var sharpness: float = SettingsFiles.get_setting("display", "fsr_sharpness")
		var quality: float = SettingsFiles.get_setting("display", "fsr_quality")
		set_fsr_sharpness(sharpness)
		set_fsr_quality(quality)
	
	
	# ADJUSTMENTS
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.adjustment_enabled = true
		var brightness: float = SettingsFiles.get_setting("display", "brightness")
		var contrast: float = SettingsFiles.get_setting("display", "contrast")
		var saturation: float = SettingsFiles.get_setting("display", "saturation")
		set_brightness(brightness)
		set_contrast(contrast)
		set_saturation(saturation)
	
	## GRAPHICS
	# LOD THRESHOLD
	var threshold: float = SettingsFiles.get_setting("rendering", "lod_threshold")
	set_lod_threshold(threshold)
	
	# SSIL
	var ssil: bool = SettingsFiles.get_setting("rendering", "ssil")
	set_ssil(ssil)
	var ssil_quality: RenderingServer.EnvironmentSSILQuality = SettingsFiles.get_setting("rendering", "ssil_quality")
	set_ssil_quality(ssil_quality)
	
	# SSR
	var ssr: bool = SettingsFiles.get_setting("rendering", "ssr")
	set_ssr(ssr)
	var ssr_steps: int = SettingsFiles.get_setting("rendering", "ssr_steps")
	set_ssr_steps(ssr_steps)
	
	# SSAO
	var ssao: bool = SettingsFiles.get_setting("rendering", "ssao")
	set_ssao(ssao)
	var ssao_quality: RenderingServer.EnvironmentSSAOQuality = SettingsFiles.get_setting("rendering", "ssao_quality")
	set_ssao_quality(ssao_quality)
	
	# GLOBAL ILLUMINATION
	var gi: GI = SettingsFiles.get_setting("rendering", "gi")
	set_gi(gi)
	var gi_res: bool = SettingsFiles.get_setting("rendering", "gi_half_res")
	set_gi_resolution(gi_res)
	
	# SDFGI
	var sdfgi_cascades: int = SettingsFiles.get_setting("rendering", "sdfgi_cascades")
	set_sdfgi_cascades(sdfgi_cascades)
	var sdfgi_rays: RenderingServer.EnvironmentSDFGIRayCount = SettingsFiles.get_setting("rendering", "sdfgi_rays")
	set_sdfgi_rays(sdfgi_rays)
	
	# VOXELGI
	var voxelgi_quality: RenderingServer.VoxelGIQuality = SettingsFiles.get_setting("rendering", "voxelgi_quality")
	set_voxelgi_quality(voxelgi_quality)
	
	# VOLUMETRIC FOG
	var volumetric_fog: bool = SettingsFiles.get_setting("rendering", "volumetric_fog")
	set_volumetric_fog(volumetric_fog)
	var volumetric_fog_filtering: bool = SettingsFiles.get_setting("rendering", "volumetric_fog_filtering")
	set_volumetric_fog_filtering(volumetric_fog_filtering)
	
	# SHADOWS
	var resolution: int = Settings.get_shadow_resolution_directional()
	set_shadow_resolution_directional(resolution)
	set_shadow_resolution_positional(resolution)
	var filtering: RenderingServer.ShadowQuality = Settings.get_shadow_filtering_directional()
	set_shadow_filtering_directional(filtering)
	set_shadow_filtering_positional(filtering)
	
	# BLOOM
	var bloom: int = get_bloom()
	set_bloom(bloom)
	
	# UI SCALE
	var scale: float = get_ui_scale()
	set_ui_scale(scale)
	
	SettingsFiles.unsaved_changes = false


# FOV
func get_fov() -> float:
	var fov: float = SettingsFiles.get_setting("game", "fov")
	return fov


func set_fov(fov: float) -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera != null:
		camera.fov = fov
	SettingsFiles.apply_setting("game", "fov", fov)


# WINDOW MODE
func get_window_mode() -> int:
	var mode: DisplayServer.WindowMode = SettingsFiles.get_setting("display", "window_mode")
	return mode


func set_window_mode(window_mode: DisplayServer.WindowMode) -> void:
	DisplayServer.window_set_mode(window_mode)
	SettingsFiles.apply_setting("display", "window_mode", window_mode)


# VSYNC
func get_vsync_mode() -> int:
	var mode: int = SettingsFiles.get_setting("display", "vsync_mode")
	return mode


func set_vsync_mode(vsync_mode: DisplayServer.VSyncMode) -> void:
	DisplayServer.window_set_vsync_mode(vsync_mode)
	SettingsFiles.apply_setting("display", "vsync_mode", vsync_mode)


# FPS LIMIT
func get_max_fps() -> int:
	var max_fps: int = SettingsFiles.get_setting("display", "max_fps")
	return max_fps


func set_max_fps(max_fps: int) -> void:
	# The maximum number of frames per second that can be rendered.
	# A value of 0 means "no limit".
	Engine.max_fps = max_fps
	SettingsFiles.apply_setting("display", "max_fps", max_fps)


# ANTI-ALISING
func get_antialiasing() -> int:
	var anti_aliasing: ANTI_ALIASING = SettingsFiles.get_setting("display", "anti_aliasing")
	return anti_aliasing


func set_antialiasing(mode: ANTI_ALIASING) -> void:
	var viewport: Viewport = get_viewport()

	disable_anti_aliasing(viewport)

	match mode:
		ANTI_ALIASING.FXAA:
			viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		ANTI_ALIASING.MSAA:
			var msaa_quality: int = Settings.get_msaa_quality()
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
func get_msaa_quality() -> int:
	var msaa: int = SettingsFiles.get_setting("display", "msaa_quality")
	return msaa


func set_msaa_quality(index: int) -> void:
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
func get_upscaler() -> Viewport.Scaling3DMode:
	var upscaler: Viewport.Scaling3DMode = SettingsFiles.get_setting("display", "upscaler")
	return upscaler


func set_upscaler(mode: Viewport.Scaling3DMode) -> void:
	var viewport: Viewport = get_viewport()
	match mode:
		Viewport.SCALING_3D_MODE_BILINEAR:
			viewport.scaling_3d_mode = mode
		Viewport.SCALING_3D_MODE_FSR2:
			viewport.scaling_3d_mode = mode
			var quality: float = get_fsr_quality()
			var sharpness: float = get_fsr_sharpness()
			viewport.scaling_3d_scale = quality
			viewport.fsr_sharpness = sharpness
	SettingsFiles.apply_setting("display", "upscaler", mode)


# FSR
func get_fsr_quality() -> float:
	var quality: float = SettingsFiles.get_setting("display", "fsr_quality")
	return quality


func set_fsr_quality(quality: float) -> void:
	var viewport: Viewport = get_viewport()
	viewport.scaling_3d_scale = quality
	SettingsFiles.apply_setting("display", "fsr_quality", quality)


func get_fsr_sharpness() -> float:
	var sharpness: float = SettingsFiles.get_setting("display", "fsr_sharpness")
	return sharpness


## FSR Sharpness is a range of 0.0 to 2.0, with 0.0 being sharpest, 2.0 being least sharp.
func set_fsr_sharpness(sharpness: float) -> void:
	var viewport: Viewport = get_viewport()
	viewport.fsr_sharpness = sharpness
	SettingsFiles.apply_setting("display", "fsr_sharpness", sharpness)


# RENDER SCALE
func get_render_scale() -> float:
	var scale: float = SettingsFiles.get_setting("display", "render_scale")
	return scale


func set_render_scale(scale: float) -> void:
	var viewport: Viewport = get_viewport()
	viewport.scaling_3d_scale = scale
	SettingsFiles.apply_setting("display", "render_scale", scale)

# ADJUSTMENTS

# BRIGHTNESS
func get_brightness() -> float:
	var brightness: float = SettingsFiles.get_setting("display", "brightness")
	return brightness

func set_brightness(brightness: float) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.set_adjustment_brightness(brightness)
	SettingsFiles.apply_setting("display", "brightness", brightness)


# CONTRAST
func get_contrast() -> float:
	var contrast: float = SettingsFiles.get_setting("display", "contrast")
	return contrast

func set_contrast(contrast: float) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.set_adjustment_contrast(contrast)
	SettingsFiles.apply_setting("display", "contrast", contrast)


# SATURATION
func get_saturation() -> float:
	var saturation: float = SettingsFiles.get_setting("display", "saturation")
	return saturation

func set_saturation(saturation: float) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.set_adjustment_saturation(saturation)
	SettingsFiles.apply_setting("display", "saturation", saturation)


## GRAPHICS
# LOD THRESHOLD
func get_lod_threshold() -> float:
	var threshold: float = SettingsFiles.get_setting("rendering", "lod_threshold")
	return threshold

func set_lod_threshold(threshold: float) -> void:
	get_tree().root.mesh_lod_threshold = threshold
	SettingsFiles.apply_setting("rendering", "lod_threshold", threshold)


# SCREEN-SPACE INDIRECT LIGHTING
func get_ssil() -> bool:
	var ssil: bool = SettingsFiles.get_setting("rendering", "ssil")
	return ssil

func set_ssil(toggle: bool) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.ssil_enabled = toggle
	SettingsFiles.apply_setting("rendering", "ssil", toggle)


func get_ssil_quality() -> RenderingServer.EnvironmentSSILQuality:
	var ssil_quality: RenderingServer.EnvironmentSSILQuality = SettingsFiles.get_setting("rendering", "ssil_quality")
	return ssil_quality

func set_ssil_quality(index: int) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		RenderingServer.environment_set_ssil_quality(index, true, 0.5, 4, 50, 300)
	SettingsFiles.apply_setting("rendering", "ssil_quality", index)


# SCREEN-SPACE REFLECTIONS
func get_ssr() -> bool:
	var ssr: bool = SettingsFiles.get_setting("rendering", "ssr")
	return ssr

func set_ssr(toggle: bool) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.set_ssr_enabled(toggle)
	SettingsFiles.apply_setting("rendering", "ssr", toggle)


func get_ssr_steps() -> int:
	var steps: int = SettingsFiles.get_setting("rendering", "ssr_steps")
	return steps

func set_ssr_steps(steps: int) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.ssr_max_steps = steps
	SettingsFiles.apply_setting("rendering", "ssr_steps", steps)


# SCREEN-SPACE AMBIENT OCCLUSION
func get_ssao() -> bool:
	var ssao: bool = SettingsFiles.get_setting("rendering", "ssao")
	return ssao

func set_ssao(toggle: bool) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.ssao_enabled = toggle
	SettingsFiles.apply_setting("rendering", "ssao", toggle)

func get_ssao_quality() -> RenderingServer.EnvironmentSSAOQuality:
	var ssao_quality: RenderingServer.EnvironmentSSAOQuality = SettingsFiles.get_setting("rendering", "ssao_quality")
	return ssao_quality

func set_ssao_quality(quality: RenderingServer.EnvironmentSSAOQuality) -> void:
	RenderingServer.environment_set_ssao_quality(quality, true, 0.5, 2, 50, 300)
	SettingsFiles.apply_setting("rendering", "ssao_quality", quality)


# GLOBAL ILLUMINATION
func get_gi() -> GI:
	var gi: GI = SettingsFiles.get_setting("rendering", "gi")
	return gi

func set_gi(gi: GI) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		reset_gi()
		match gi:
			GI.VOXELGI:
				pass # TODO: Figure out a good way to fetch and toggle voxelGI
			GI.SDFGI:
				environment.sdfgi_enabled = true
		
	SettingsFiles.apply_setting("rendering", "gi", gi)

func reset_gi() -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.sdfgi_enabled = false
	# TODO: Figure out a good way to fetch and toggle voxelGI

func get_gi_resolution() -> bool:
	var gi_res: bool = SettingsFiles.get_setting("rendering", "gi_half_res")
	return gi_res

func set_gi_resolution(index: int) -> void:
	RenderingServer.gi_set_use_half_resolution(index == 1)
	SettingsFiles.apply_setting("rendering", "gi_half_res", index == 1)

# SDFGI
func get_sdfgi_cascades() -> int:
	var sdfgi_cascades: int = SettingsFiles.get_setting("rendering", "sdfgi_cascades")
	return sdfgi_cascades

# Between 1 and 8
func set_sdfgi_cascades(cascades: int) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.sdfgi_cascades = cascades
	SettingsFiles.apply_setting("rendering", "sdfgi_cascades", cascades)

func get_sdfgi_rays() -> RenderingServer.EnvironmentSDFGIRayCount:
	var rays: RenderingServer.EnvironmentSDFGIRayCount = SettingsFiles.get_setting("rendering", "sdfgi_rays")
	return rays

func set_sdfgi_rays(ray_count: RenderingServer.EnvironmentSDFGIRayCount) -> void:
	RenderingServer.environment_set_sdfgi_ray_count(ray_count)
	SettingsFiles.apply_setting("rendering", "sdfgi_rays", ray_count)

# VOXEL GI
func get_voxelgi_quality() -> RenderingServer.VoxelGIQuality:
	var voxelgi_quality: RenderingServer.VoxelGIQuality = SettingsFiles.get_setting("rendering", "voxelgi_quality")
	return voxelgi_quality

func set_voxelgi_quality(quality: RenderingServer.VoxelGIQuality) -> void:
	RenderingServer.voxel_gi_set_quality(quality)
	SettingsFiles.apply_setting("rendering", "voxelgi_quality", quality)


# VOLUMETRIC FOG
func get_volumetric_fog() -> bool:
	var volumetric_fog: bool = SettingsFiles.get_setting("rendering", "volumetric_fog")
	return volumetric_fog

func set_volumetric_fog(toggle: bool) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.volumetric_fog_enabled = toggle
	SettingsFiles.apply_setting("rendering", "volumetric_fog", toggle)

func get_volumetric_fog_filtering() -> bool:
	var filtering: bool = SettingsFiles.get_setting("rendering", "volumetric_fog_filtering")
	return filtering

func set_volumetric_fog_filtering(toggle: bool) -> void:
	RenderingServer.environment_set_volumetric_fog_filter_active(toggle)
	SettingsFiles.apply_setting("rendering", "volumetric_fog_filtering", toggle)

# SHADOWS
func get_shadow_resolution_directional() -> int:
	var res_directional: int = SettingsFiles.get_setting("rendering", "shadow_resolution_directional")
	return res_directional

func set_shadow_resolution_directional(resolution: int) -> void:
	RenderingServer.directional_shadow_atlas_set_size(resolution, true)
	SettingsFiles.apply_setting("rendering", "shadow_resolution_directional", resolution)

func get_shadow_resolution_positional() -> int:
	var res_positional: int = SettingsFiles.get_setting("rendering", "shadow_resolution_positional")
	return res_positional

func set_shadow_resolution_positional(resolution: int) -> void:
	get_viewport().positional_shadow_atlas_size = resolution
	SettingsFiles.apply_setting("rendering", "shadow_resolution_positional", resolution)


func get_shadow_filtering_directional() -> RenderingServer.ShadowQuality:
	var shadow_quality: RenderingServer.ShadowQuality = SettingsFiles.get_setting("rendering", "shadow_filtering_directional")
	return shadow_quality

func set_shadow_filtering_directional(quality: RenderingServer.ShadowQuality) -> void:
	RenderingServer.directional_soft_shadow_filter_set_quality(quality)
	SettingsFiles.apply_setting("rendering", "shadow_filtering_directional", quality)


func get_shadow_filtering_positional() -> RenderingServer.ShadowQuality:
	var shadow_quality: RenderingServer.ShadowQuality = SettingsFiles.get_setting("rendering", "shadow_filtering_positional")
	return shadow_quality

func set_shadow_filtering_positional(quality: RenderingServer.ShadowQuality) -> void:
	RenderingServer.positional_soft_shadow_filter_set_quality(quality)
	SettingsFiles.apply_setting("rendering", "shadow_filtering_positional", quality)


# BLOOM
func get_bloom() -> bool:
	var bloom: bool = SettingsFiles.get_setting("rendering", "bloom")
	return bloom

func set_bloom(bloom: bool) -> void:
	var environment: Environment = get_viewport().get_world_3d().environment
	if environment != null:
		environment.glow_bloom = bloom
	SettingsFiles.apply_setting("rendering", "bloom", bloom)

func get_bloom_bicubic() -> bool:
	var bicubic: bool = SettingsFiles.get_setting("rendering", "bloom_bicubic")
	return bicubic

func set_bloom_bicubic(bicubic: bool) -> void:
	RenderingServer.environment_glow_set_use_bicubic_upscale(bicubic)
	SettingsFiles.apply_setting("rendering", "bloom_bicubic", bicubic)

## Audio
func get_volume(bus_index: int) -> float:
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


func set_volume(index: int, volume: float) -> void:
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
			SettingsFiles.apply_setting("audio", "volume", adjusted_volume)

## UI

func get_ui_scale() -> float:
	var scale: float = SettingsFiles.get_setting("ui", "scale")
	return scale

func set_ui_scale(scale: float) -> void:
	var new_size := viewport_start_size
	new_size *= scale
	get_tree().root.set_content_scale_size(new_size)
	SettingsFiles.apply_setting("ui", "scale", scale)
