extends Control

@onready var fov_slider: SliderWithValue = $FOV


func _ready() -> void:
	var fov: float = Settings.get_fov()
	fov_slider.set_value_no_signal(fov)


func _on_fov_slider_value_changed(value: float) -> void:
	var fov := int(value)
	Settings.set_fov(fov)
