extends Control

@onready var gi_options: OptionButton = $GIOptions
@onready var gi_resolution_option: OptionButton = $GIResolutionOption
@onready var sdfgi_cascades_label: Label = $SDFGICascadesLabel
@onready var sdfgi_cascades_slider: SliderWithValue = $SDFGICascadesSlider
@onready var sdfgi_probe_rays_label: Label = $SDFGIProbeRaysLabel
@onready var sdfgi_probe_rays_options: OptionButton = $SDFGIProbeRaysOptions
@onready var voxel_gi_quality_label: Label = $VoxelGIQualityLabel
@onready var voxel_gi_quality_options: OptionButton = $VoxelGIQualityOptions


func _ready() -> void:
	var gi: Settings.GI = Settings.graphics_get_gi()
	gi_options.set_block_signals(true)
	gi_options.select(gi)
	gi_options.set_block_signals(false)
	toggle_submenu(gi)
	
	var gi_res: bool = Settings.graphics_get_gi_resolution()
	gi_resolution_option.set_block_signals(true)
	match gi_res:
		true: gi_resolution_option.select(0)
		false: gi_resolution_option.select(1)
	gi_resolution_option.set_block_signals(false)
	
	var sdfgi_cascades: int = Settings.graphics_get_sdfgi_cascades()
	sdfgi_cascades_slider.set_block_signals(true)
	sdfgi_cascades_slider.slider_value = sdfgi_cascades
	sdfgi_cascades_slider.set_block_signals(false)
	
	var rays: int = Settings.graphics_get_sdfgi_rays()
	sdfgi_probe_rays_options.set_block_signals(true)
	sdfgi_probe_rays_options.select(rays)
	sdfgi_probe_rays_options.set_block_signals(false)
	
	var voxelgi_quality: int = Settings.graphics_get_voxelgi_quality()
	voxel_gi_quality_options.set_block_signals(true)
	voxel_gi_quality_options.select(voxelgi_quality)
	voxel_gi_quality_options.set_block_signals(false)


func toggle_submenu(index: int) -> void:
	sdfgi_cascades_label.visible = index == 2
	sdfgi_cascades_slider.visible = index == 2
	sdfgi_probe_rays_label.visible = index == 2
	sdfgi_probe_rays_options.visible = index == 2
	voxel_gi_quality_label.visible = index == 1
	voxel_gi_quality_options.visible = index == 1


func _on_global_illumination_options_item_selected(index: int) -> void:
	match index:
		0: Settings.graphics_set_gi(Settings.GI.DISABLED)
		1: Settings.graphics_set_gi(Settings.GI.VOXELGI)
		2: Settings.graphics_set_gi(Settings.GI.SDFGI)
	toggle_submenu(index)

func _on_gi_resolution_option_item_selected(index: int) -> void:
	Settings.graphics_set_gi_resolution(index != 1)

func _on_sdfgi_cascades_slider_slider_value_changed(cascades: int) -> void:
	Settings.graphics_set_sdfgi_cascades(cascades)

func _on_sdfgi_probe_rays_options_item_selected(index: int) -> void:
	Settings.graphics_set_sdfgi_rays(index)

func _on_voxel_gi_quality_options_item_selected(index: int) -> void:
	Settings.graphics_set_voxelgi_quality(index)
