extends Control

var viewport_start_size := Vector2(
	ProjectSettings.get_setting(&"display/window/size/viewport_width"),
	ProjectSettings.get_setting(&"display/window/size/viewport_height")
)

@onready var ui_scaling_slider: SliderWithValue = $UIScalingSlider

func _ready() -> void:
	var ui_scale: float = Settings.ui_get_ui_scale() * 100
	#ui_scaling_slider.set_block_signals(true)
	#ui_scaling_slider.value = ui_scale
	#ui_scaling_slider.set_block_signals(false)
	#
	#ui_scaling_slider.set_block_signals(true)
	match ui_scale:
		1.5: ui_scaling_slider.select(0)
		1.25: ui_scaling_slider.select(1)
		1: ui_scaling_slider.select(2)
		0.75: ui_scaling_slider.select(3)
		0.5: ui_scaling_slider.select(4)
	ui_scaling_slider.set_block_signals(false)

#func _on_ui_scaling_slider_slider_value_changed(value: float) -> void:
	#Settings.ui_set_ui_scale(value / 100)


func _on_ui_scaling_options_item_selected(index: int) -> void:
	match index:
		0: Settings.ui_set_ui_scale(1.5)
		1: Settings.ui_set_ui_scale(1.25)
		2: Settings.ui_set_ui_scale(1)
		3: Settings.ui_set_ui_scale(0.75)
		4: Settings.ui_set_ui_scale(0.5)
