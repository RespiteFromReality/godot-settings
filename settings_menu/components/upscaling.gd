extends Control

@onready var upscaling: OptionButton = $Upscaling
@onready var render_scale_label: Label = $RenderScaleLabel
@onready var render_scale_slider: SliderWithValue = $RenderScaleSlider
@onready var fsr_quality_label: Label = $FSRQualityLabel
@onready var fsr_quality_dropdown: OptionButton = $FSRQualityDropdown
@onready var fsr_sharpness_label: Label = $FSRSharpnessLabel
@onready var fsr_sharpness_slider: SliderWithValue = $FSRSharpnessSlider


func _ready() -> void:
	#UPSCALING
	var upscaler: Viewport.Scaling3DMode = Settings.display_get_upscaler()
	upscaling.set_block_signals(true)
	match upscaler:
		Viewport.SCALING_3D_MODE_BILINEAR: 
			upscaling.select(0)
			toggle_upscaling_submenu(0)
		Viewport.SCALING_3D_MODE_FSR2:
			upscaling.select(1)
			toggle_upscaling_submenu(1)
	upscaling.set_block_signals(false)
	
	#FSR
	var fsr_quality: float = Settings.display_get_fsr_quality()
	fsr_quality_dropdown.set_block_signals(true)
	var index: int = -1
	match fsr_quality:
		1.0:
			index = 0
		0.77:
			index = 1
		0.67:
			index = 2
		0.59:
			index = 3
		0.50:
			index = 4
	fsr_quality_dropdown.select(index)
	fsr_quality_dropdown.set_block_signals(false)

	var fsr_sharpness: float = Settings.display_get_fsr_sharpness()
	fsr_sharpness_slider.set_block_signals(true)
	fsr_sharpness_slider.slider_value = invert_sharpness(0, 2, fsr_sharpness)
	fsr_sharpness_slider.set_block_signals(false)

	var render_scale: float = Settings.display_get_render_scale()
	render_scale_slider.set_block_signals(true)
	render_scale_slider.slider_value = render_scale
	render_scale_slider.set_block_signals(false)


func invert_sharpness(_min: float, _max: float, value: float) -> float:
	return _max - value + _min


func toggle_upscaling_submenu(index: int) -> void:
	match index:
		0: # No Upscaling
			render_scale_label.visible = true
			render_scale_slider.visible = true
			fsr_quality_label.visible = false
			fsr_quality_dropdown.visible = false
			fsr_sharpness_label.visible = false
			fsr_sharpness_slider.visible = false
		1: # FSR 2.2
			render_scale_label.visible = false
			render_scale_slider.visible = false
			fsr_quality_label.visible = true
			fsr_quality_dropdown.visible = true
			fsr_sharpness_label.visible = true
			fsr_sharpness_slider.visible = true


func _on_fsr_quality_dropdown_item_selected(index: int) -> void:
	match index:
		0:
			Settings.display_set_fsr_quality(1.0)
		1:
			Settings.display_set_fsr_quality(0.77)
		2:
			Settings.display_set_fsr_quality(0.67)
		3:
			Settings.display_set_fsr_quality(0.59)
		4:
			Settings.display_set_fsr_quality(0.50)


# FSR sharpening is an inverted range where 0 is sharpest and 2.0 is the least
# sharp. The slider provides a more standard 0-2 range and the value is inverted
# for the engine.
func _on_fsr_sharpness_slider_slider_value_changed(value: float) -> void:
	var sharpness: float = invert_sharpness(0, 2, value)
	Settings.display_set_fsr_sharpness(sharpness)


func _on_render_scale_slider_slider_value_changed(value: float) -> void:
	Settings.display_set_render_scale(value)


func _on_upscaling_item_selected(index: int) -> void:
	toggle_upscaling_submenu(index)
	match index:
		0:
			Settings.display_set_upscaler(Viewport.SCALING_3D_MODE_BILINEAR)
			Settings.display_set_render_scale(render_scale_slider.slider_value)
		1:
			Settings.display_set_upscaler(Viewport.SCALING_3D_MODE_FSR2)
