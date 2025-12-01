@tool
class_name SliderWithValue
extends Control 

signal slider_value_changed(value: float)


@export_category("Slider")
@export var editable: bool = true
@export var rounded: bool = false
@export var min_value: float = 0
@export var max_value: float = 100
@export var value: float = 0
@export var step: float = 1
@export_category("Label")
@export var label_toggle: bool = true
@export var zero_means_disabled: bool = false
@export_range(0, 2, 1, "or_greater") var decimals_padding: int = 1
## A string suffix appended after the value, leave empty for none.
@export var suffix: String = ""

@onready var h_slider: HSlider = $HSlider
@onready var label: ToggleableLabel = $Label


func _ready() -> void:
	h_slider.set_block_signals(true)
	set_editable(editable)
	set_min_value(min_value)
	set_max_value(max_value)
	set_rounded(rounded)
	set_value(value)
	set_step(step)
	h_slider.set_block_signals(false)
	
	label.set_block_signals(true)
	set_label_value(value)
	label.set_block_signals(false)
# Config functions

# Slider
func get_editable() -> bool:
	return h_slider.editable

func set_editable(_editable: bool) -> void:
	h_slider.editable = _editable

func get_min_value() -> float:
	return h_slider.min_value

func set_min_value(_min_value: float) -> void:
	h_slider.min_value = _min_value

func get_max_value() -> float:
	return h_slider.max_value

func set_max_value(_max_value: float) -> void:
	h_slider.max_value = max_value

func get_rounded() -> bool:
	return h_slider.rounded

func set_rounded(_rounded: bool) -> void:
	h_slider.rounded = _rounded

func get_step() -> float:
	return h_slider.step

func set_step(_step: float) -> void:
	h_slider.step = step

func get_value() -> float:
	return h_slider.value

func set_value(_value: float) -> void:
	h_slider.value = _value

func set_value_no_signal(_value: float) -> void:
	self.set_block_signals(true)
	h_slider.value = _value
	self.set_block_signals(false)

# Label
func get_label_value() -> String:
	return label.text

func set_label_value(_value: float) -> void:
	if _value == 0 && zero_means_disabled == true:
		label.text = "Disabled"
	else:
		label.text = str(_value).pad_decimals(decimals_padding) + suffix


# Signals

func _on_h_slider_value_changed(_value: float) -> void:
	set_label_value(_value)
	slider_value_changed.emit(_value)


# Editor
func _get_configuration_warnings() -> PackedStringArray: # Creates editor warnings 
	var msgs: PackedStringArray
	if slider_value_changed.has_connections() != true:
		msgs.append("This component has no connections to any of its signals!")
	if max_value < min_value:
		msgs.append("Slider max range must be more than min range!")
	if value > max_value || value < min_value:
		msgs.append("The starting value is smaller or largest than the range!")
	if step == 0:
		msgs.append("Slider cannot have 0 steps!")
	if decimals_padding < 0:
		msgs.append("Decimal padding cannot be a negative value! ")
	return msgs
