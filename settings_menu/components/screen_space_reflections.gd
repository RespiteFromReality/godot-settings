extends Control

@onready var ssr_options: OptionButton = $SSROptions
@onready var ssr_steps_label: Label = $SSRStepsLabel
@onready var ssr_steps_slider: SliderWithValue = $SSRStepsSlider


func _ready() -> void:
	initialize_settings()
	Settings.reload_settings.connect(initialize_settings)


func initialize_settings() -> void:
	var ssr: bool = Settings.get_ssr()
	ssr_options.set_block_signals(true)
	ssr_options.select(int(ssr))
	ssr_options.set_block_signals(false)
	toggle_submenu(int(ssr))
	
	var ssr_steps: int = Settings.get_ssr_steps()
	ssr_steps_slider.set_value_no_signal(ssr_steps)


func toggle_submenu(index: int) -> void:
	ssr_steps_label.visible = index == 1
	ssr_steps_slider.visible = index == 1


func _on_ssr_options_item_selected(index: int) -> void:
	Settings.set_ssr(index == 1)
	toggle_submenu(index)

func _on_screen_space_reflections_quality_slider_slider_value_changed(value: int) -> void:
	Settings.set_ssr_steps(value)
