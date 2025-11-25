@tool
class_name FPSSlider
extends Control

signal drag_started
signal drag_ended(value: float)


@export_category("Slider")
@export var editable: bool = true
@export var min_value: float = 0
@export var max_value: float = 100
@export var step: float = 1
@export var value: float = 0
@export var zero_means_disabled: bool = false
@export_category("Label")
@export var enabled: bool = true

@onready var h_slider: HSlider = $HSlider
@onready var label: ToggleableLabel = $Label


func _ready() -> void:
	h_slider.set_block_signals(true)
	set_editable(editable)
	set_min_value(min_value)
	set_max_value(max_value)
	set_step(step)
	set_value(value)
	h_slider.set_block_signals(false)
	
	label.set_block_signals(true)
	set_label_value(get_value())
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
func get_label_enabled() -> bool:
	return label.enabled

func set_label_enabled(_enabled: bool) -> void:
	label.enabled = _enabled

func get_label_value() -> String:
	return label.text

func set_label_value(_value: float) -> void:
	if _value == 0 && zero_means_disabled == true:
		label.text = "Disabled"
	else:
		label.text = str(_value).pad_decimals(0) + " FPS"


# Signals
func _on_h_slider_drag_started() -> void:
	drag_started.emit()

func _on_h_slider_drag_ended(_value_changed: bool) -> void:
	drag_ended.emit(get_value())

func _on_h_slider_value_changed(slider_value: float) -> void:
	set_label_value(slider_value)


# Editor
func _get_configuration_warnings() -> PackedStringArray: # Creates editor warnings 
	var msgs: PackedStringArray
	if drag_ended.has_connections() != true && drag_started.has_connections() != null:
		msgs.append("This component has no connections to its signal!")
	if max_value < min_value:
		msgs.append("Slider max value must be more than min value!")
	if value > max_value || value < min_value:
		msgs.append("The starting value is smaller or larger than the set range!")
	if step == 0:
		msgs.append("Slider cannot have 0 steps!")
	return msgs
