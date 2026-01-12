extends Control

@onready var aa_option_button: OptionButton = $AAOptionButton
@onready var msaa_quality_label: Label = %MSAAQualityLabel
@onready var msaa_quality_options: OptionButton = %MSAAQualityOptions


func _ready() -> void:
	#AA
	var anti_aliasing: int = Settings.get_antialiasing()
	aa_option_button.set_block_signals(true)
	aa_option_button.select(anti_aliasing)
	aa_option_button.set_block_signals(false)
	toggle_msaa_submenu(anti_aliasing)

	#MSAA
	var msaa_quality: int = Settings.get_msaa_quality()
	msaa_quality_options.set_block_signals(true)
	match msaa_quality:
		2: msaa_quality_options.select(0)
		4: msaa_quality_options.select(1)
		8: msaa_quality_options.select(2)
	msaa_quality_options.set_block_signals(false)


func toggle_msaa_submenu(index: int) -> void:
	if index == 2:
		msaa_quality_label.visible = true
		msaa_quality_options.visible = true
	else:
		msaa_quality_label.visible = false
		msaa_quality_options.visible = false


func _on_aa_option_button_item_selected(index: int) -> void:
	toggle_msaa_submenu(index)
	match index:
		0: Settings.set_antialiasing(Settings.ANTI_ALIASING.DISABLED)
		1: Settings.set_antialiasing(Settings.ANTI_ALIASING.FXAA)
		2: Settings.set_antialiasing(Settings.ANTI_ALIASING.SMAA)
		3: Settings.set_antialiasing(Settings.ANTI_ALIASING.MSAA)
		4: Settings.set_antialiasing(Settings.ANTI_ALIASING.TAA)


func _on_msaa_quality_options_item_selected(index: int) -> void:
	Settings.set_msaa_quality(index)
