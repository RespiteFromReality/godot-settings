extends Control

const color_greyed_out = Color.DIM_GRAY
const color_white = Color.WHITE

@onready var vsync: OptionButton = $VSync
@onready var fps_limit_toggleable_label: ToggleableLabel = $FPSLimitToggleableLabel
@onready var fps_limit_slider: FPSSlider = $FPSLimitSlider


func _ready() -> void:
	initialize_settings()
	Settings.reload_settings.connect(initialize_settings)


func initialize_settings() -> void:
	var vsync_index: int = Settings.get_vsync_mode()
	vsync.set_block_signals(true)
	vsync.select(vsync_index)
	vsync.set_block_signals(false)
	if (vsync_index != 0):
		toggle_fps_limiter(false)
	else:
		toggle_fps_limiter(true)

	var max_fps: int = Settings.get_max_fps()
	fps_limit_slider.set_block_signals(true)
	fps_limit_slider.set_value(max_fps)
	fps_limit_slider.set_block_signals(false)


func toggle_fps_limiter(state: bool) -> void:
	fps_limit_toggleable_label.enabled = state
	fps_limit_slider.set_label_enabled(state)
	fps_limit_slider.set_editable(state)


func _on_vsync_item_selected(index: int) -> void:
	match index:
		0: # Disabled (uses Engine.max_fps)
			toggle_fps_limiter(true)
			Settings.set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1: # Adaptive V-sync: Framerate is limited by the monitor refresh rate. (ignores Engine.max_fps)
			toggle_fps_limiter(false)
			Settings.set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		2: # Enabled V-sync: Framerate is limited by the monitor refresh rate. (ignores Engine.max_fps)
			toggle_fps_limiter(false)
			Settings.set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)


# To ensure smooth sliding, when the drag starts we set the FPS to 60.
func _on_fps_limit_slider_drag_started() -> void:
	Settings.set_max_fps(60)


func _on_fps_limit_slider_drag_ended(value: int) -> void:
	var max_fps: int = value
	Settings.set_max_fps(max_fps)
