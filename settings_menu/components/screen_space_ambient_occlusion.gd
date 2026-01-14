extends Control

@onready var ssao_options: OptionButton = $SSAOOptions
@onready var ssao_quality_label: Label = $SSAOQualityLabel
@onready var ssao_quality_options: OptionButton = $SSAOQualityOptions

func _ready() -> void:
	initialize_settings()
	Settings.reload_settings.connect(initialize_settings)


func initialize_settings() -> void:
	var ssao: bool = Settings.get_ssao()
	ssao_options.set_block_signals(true)
	ssao_options.select(int(ssao))
	ssao_options.set_block_signals(false)
	toggle_submenu(int(ssao))
	
	var ssao_quality: RenderingServer.EnvironmentSSAOQuality = Settings.get_ssao_quality()
	ssao_quality_options.set_block_signals(true)
	ssao_quality_options.select(ssao_quality)
	ssao_quality_options.set_block_signals(false)


func toggle_submenu(index: int) -> void:
	ssao_quality_label.visible = index == 1
	ssao_quality_options.visible = index == 1


func _on_ssao_options_item_selected(index: int) -> void:
	Settings.set_ssao(index == 1)
	toggle_submenu(index)

func _on_ssao_quality_options_item_selected(index: int) -> void:
	Settings.set_ssao_quality(index)
