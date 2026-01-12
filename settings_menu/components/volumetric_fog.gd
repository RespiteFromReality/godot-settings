extends Control

@onready var volumetric_fog_options: OptionButton = $VolumetricFogOptions
@onready var volumetric_fog_filtering_label: Label = $VolumetricFogFilteringLabel
@onready var volumetric_fog_filtering_options: OptionButton = $VolumetricFogFilteringOptions

func _ready() -> void:
	var fog: bool = Settings.get_volumetric_fog()
	volumetric_fog_options.set_block_signals(true)
	volumetric_fog_options.select(int(fog))
	volumetric_fog_options.set_block_signals(false)
	toggle_submenu(fog)
	
	var filtering: bool = Settings.get_volumetric_fog_filtering()
	volumetric_fog_filtering_options.set_block_signals(true)
	volumetric_fog_filtering_options.select(filtering)
	volumetric_fog_filtering_options.set_block_signals(false)


func toggle_submenu(index: int) -> void:
	volumetric_fog_filtering_label.visible = index == 1
	volumetric_fog_filtering_options.visible = index == 1


func _on_volumetric_fog_options_item_selected(index: int) -> void:
	Settings.set_volumetric_fog(index == 1)
	toggle_submenu(index == 1)

func _on_volumetric_fog_filtering_options_item_selected(index: int) -> void:
	Settings.set_volumetric_fog_filtering(index == 1)
