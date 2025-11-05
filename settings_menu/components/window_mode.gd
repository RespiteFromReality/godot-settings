extends Control

@onready var window_mode_button: OptionButton = %WindowModeButton


func _ready() -> void:
	var mode: int = Settings.display_get_window_mode()
	window_mode_button.set_block_signals(true)
	match mode:
		0:
			window_mode_button.select(0)
		3:
			window_mode_button.select(1)
		4:
			window_mode_button.select(2)
			
	window_mode_button.set_block_signals(false)


func _on_window_mode_button_item_selected(index: int) -> void:
	match index:
		0:
			Settings.display_set_window_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			Settings.display_set_window_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			Settings.display_set_window_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
