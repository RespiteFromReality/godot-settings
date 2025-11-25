extends Control

@onready var fov_slider: SliderWithValue = $FOV


func _ready() -> void:
	var fov: float = Settings.game_get_fov()
	fov_slider.set_value_no_signal(fov)


func _on_fov_slider_value_changed(value: float) -> void:
	var fov := int(value)
	Settings.game_set_fov(fov)
