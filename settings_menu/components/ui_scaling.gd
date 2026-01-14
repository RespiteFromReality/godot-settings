extends Control

var viewport_start_size := Vector2(
	ProjectSettings.get_setting(&"display/window/size/viewport_width"),
	ProjectSettings.get_setting(&"display/window/size/viewport_height")
)

@onready var ui_scaling_options: OptionButton = $UIScalingOptions

func _ready() -> void:
	initialize_settings()
	Settings.reload_settings.connect(initialize_settings)


func initialize_settings() -> void:
	var ui_scale: float = Settings.get_ui_scale()
	ui_scaling_options.set_block_signals(true)
	match ui_scale:
		1.5: ui_scaling_options.select(0)
		1.25: ui_scaling_options.select(1)
		1.0: ui_scaling_options.select(2)
		0.75: ui_scaling_options.select(3)
		0.5: ui_scaling_options.select(4)
	ui_scaling_options.set_block_signals(false)


func _on_ui_scaling_options_item_selected(index: int) -> void:
	match index:
		0: Settings.set_ui_scale(1.5)
		1: Settings.set_ui_scale(1.25)
		2: Settings.set_ui_scale(1)
		3: Settings.set_ui_scale(0.75)
		4: Settings.set_ui_scale(0.5)
