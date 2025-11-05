extends Control

const color_greyed_out = Color.DIM_GRAY
const color_white = Color.WHITE

@onready var vsync: OptionButton = $VSync
@onready var fps_limit_toggleable_label: ToggleableLabel = $FPSLimitToggleableLabel
@onready var fps_limit: SliderWithValue = $FPSLimit


func _ready() -> void:
	var vsync_index: int = Settings.display_get_vsync_mode()
	vsync.set_block_signals(true)
	vsync.select(vsync_index)
	vsync.set_block_signals(false)
	if (vsync_index != 0):
		toggle_fps_limiter(false)

	var max_fps: int = Settings.display_get_max_fps()
	fps_limit.set_block_signals(true)
	fps_limit.slider_value = max_fps
	fps_limit.set_block_signals(false)


func toggle_fps_limiter(state: bool) -> void:
	fps_limit.editable_slider = state
	fps_limit.label_toggle = state
	fps_limit_toggleable_label.enabled = state


func _on_vsync_item_selected(index: int) -> void:
	match index:
		0: # Disabled (uses Engine.max_fps)
			toggle_fps_limiter(true)
			Settings.display_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1: # Adaptive V-sync: Framerate is limited by the monitor refresh rate. (ignores Engine.max_fps)
			toggle_fps_limiter(false)
			Settings.display_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		2: # Enabled V-sync: Framerate is limited by the monitor refresh rate. (ignores Engine.max_fps)
			toggle_fps_limiter(false)
			Settings.display_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)


func _on_fps_limit_drag_ended(value: float) -> void:
	var max_fps: int = int(value)
	Settings.display_set_max_fps(max_fps)
