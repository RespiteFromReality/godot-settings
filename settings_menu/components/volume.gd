extends Control

## Audio
var master_index: int = AudioServer.get_bus_index("Master")
var music_index: int = AudioServer.get_bus_index("Music")
var effects_index: int = AudioServer.get_bus_index("Effects")
var ambient_index: int = AudioServer.get_bus_index("Ambient")
var voice_index: int = AudioServer.get_bus_index("Voice")
var ui_index: int = AudioServer.get_bus_index("UI")

@onready var master_volume_slider: SliderWithValue = $MasterVolumeSlider
@onready var music_volume_slider: SliderWithValue = $MusicVolumeSlider
@onready var effects_volume_slider: SliderWithValue = $EffectsVolumeSlider
@onready var ambient_volume_slider: SliderWithValue = $AmbientVolumeSlider
@onready var voice_volume_slider: SliderWithValue = $VoiceVolumeSlider
@onready var ui_volume_slider: SliderWithValue = $UIVolumeSlider


func _ready() -> void:
	var master_volume: float = Settings.get_volume(master_index)
	var music_volume: float = Settings.get_volume(music_index)
	var effects_volume: float = Settings.get_volume(effects_index)
	var ambient_volume: float = Settings.get_volume(ambient_index)
	var voice_volume: float = Settings.get_volume(voice_index)
	var ui_volume: float = Settings.get_volume(ui_index)
	master_volume_slider.set_value_no_signal(master_volume * 100)
	music_volume_slider.set_value_no_signal(music_volume * 100)
	effects_volume_slider.set_value_no_signal(effects_volume * 100)
	ambient_volume_slider.set_value_no_signal(ambient_volume * 100)
	voice_volume_slider.set_value_no_signal(voice_volume * 100)
	ui_volume_slider.set_value_no_signal(ui_volume * 100)


func _on_master_volume_slider_value_changed(value: float) -> void:
	Settings.set_volume(master_index, value / 100)


func _on_music_volume_slider_value_changed(value: float) -> void:
	Settings.set_volume(music_index, value / 100)


func _on_effects_volume_slider_value_changed(value: float) -> void:
	Settings.set_volume(effects_index, value / 100)


func _on_ambient_volume_slider_value_changed(value: float) -> void:
	Settings.set_volume(ambient_index, value / 100)


func _on_voice_volume_slider_value_changed(value: float) -> void:
	Settings.set_volume(voice_index, value / 100)


func _on_ui_volume_slider_value_changed(value: float) -> void:
	Settings.set_volume(ui_index, value / 100)
