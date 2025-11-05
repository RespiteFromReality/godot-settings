@tool
extends Label
class_name ToggleableLabel

@export var enabled: bool = true :
	get: return enabled
	set(value):
		toggle_label(value)
		enabled = value

@export var font_color = Color.WHITE
@export var greyed_out_color = Color.DIM_GRAY

func toggle_label(state: bool) -> void:
	if state:
		set("theme_override_colors/font_color", font_color)
	else:
		set("theme_override_colors/font_color", greyed_out_color)
