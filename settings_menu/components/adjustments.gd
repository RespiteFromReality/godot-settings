extends Control

@onready var brightness_slider: SliderWithValue = $Brightness
@onready var contrast_slider: SliderWithValue = $Contrast
@onready var saturation_slider: SliderWithValue = $Saturation


func _ready() -> void:
	initialize_settings()
	Settings.reload_settings.connect(initialize_settings)


func initialize_settings() -> void:
	var brightness: float = Settings.get_brightness()
	brightness_slider.set_value_no_signal(brightness)
	
	var constrast: float = Settings.get_contrast()
	contrast_slider.set_value_no_signal(constrast)
	
	var saturation: float = Settings.get_saturation()
	saturation_slider.set_value_no_signal(saturation)

# Color Adjustments
# these is a settings are attached to the environment.
# If your game requires you to change the environment,
# then be sure to run this function again to make the settings effective.
func _on_brightness_slider_value_changed(value: float) -> void:
	Settings.set_brightness(value)


func _on_contrast_slider_value_changed(value: float) -> void:
	Settings.set_contrast(value)


func _on_saturation_slider_value_changed(value: float) -> void:
	Settings.set_saturation(value)
