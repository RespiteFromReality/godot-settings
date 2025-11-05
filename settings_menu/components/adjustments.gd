extends Control

@onready var brightness_slider: SliderWithValue = $Brightness
@onready var contrast_slider: SliderWithValue = $Contrast
@onready var saturation_slider: SliderWithValue = $Saturation


func _ready() -> void:
	var brightness: float = Settings.display_get_brightness()
	brightness_slider.set_block_signals(true)
	brightness_slider.slider_value = brightness
	brightness_slider.set_block_signals(false)
	var constrast: float = Settings.display_get_contrast()
	contrast_slider.set_block_signals(true)
	contrast_slider.slider_value = constrast
	contrast_slider.set_block_signals(false)
	var saturation: float = Settings.display_get_saturation()
	saturation_slider.set_block_signals(true)
	saturation_slider.slider_value = saturation
	saturation_slider.set_block_signals(false)


# Color Adjustments
# these is a settings are attached to the environment.
# If your game requires you to change the environment,
# then be sure to run this function again to make the settings effective.
func _on_brightness_slider_value_changed(value: float) -> void:
	Settings.display_set_brightness(value)


func _on_contrast_slider_value_changed(value: float) -> void:
	Settings.display_set_contrast(value)


func _on_saturation_slider_value_changed(value: float) -> void:
	Settings.display_set_saturation(value)
