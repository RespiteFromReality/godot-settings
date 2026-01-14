extends Control

@onready var ssil_options: OptionButton = $SSILOptions
@onready var ssil_quality_label: Label = $SSILQualityLabel
@onready var ssil_quality_options: OptionButton = $SSILQualityOptions


func _ready() -> void:
	initialize_settings()
	Settings.reload_settings.connect(initialize_settings)


func initialize_settings() -> void:
	var ssil: bool = Settings.get_ssil()
	ssil_options.set_block_signals(true)
	ssil_options.select(int(ssil))
	ssil_options.set_block_signals(false)
	toggle_ssil_submenu(int(ssil))
	
	var ssil_quality: RenderingServer.EnvironmentSSILQuality = Settings.get_ssil_quality()
	ssil_quality_options.set_block_signals(true)
	ssil_quality_options.select(ssil_quality)
	ssil_quality_options.set_block_signals(false)


func toggle_ssil_submenu(index: int) -> void:
	ssil_quality_label.visible = index == 1
	ssil_quality_options.visible = index == 1


func _on_ssil_options_item_selected(index: int) -> void:
	Settings.set_ssil(index == 1)
	toggle_ssil_submenu(index == 1)


func _on_ssil_quality_options_item_selected(index: int) -> void:
	Settings.set_ssil_quality(index)
