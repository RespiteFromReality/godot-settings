extends Control

@onready var threshold_slider: SliderWithValue = $LODThreshold


func _ready() -> void:
	var threshold: float = Settings.graphics_get_lod_threshold()
	threshold_slider.set_value_no_signal(threshold)


func _on_lod_threshold_slider_value_changed(lod_threshold: float) -> void:
	Settings.graphics_set_lod_threshold(lod_threshold)
