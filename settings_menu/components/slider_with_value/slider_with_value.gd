@tool

extends Control 
class_name SliderWithValue

signal slider_value_changed(value: float)
signal drag_ended(value: float)

@export_category("Slider")
@export var editable_slider: bool = true :
	get(): return %HSlider.editable
	set(value): %HSlider.editable = value
@export var slider_range_min: float
@export var slider_range_max: float
@export var slider_starting_value: float
@export var slider_steps: float
@export var zero_means_disabled: bool
@export_category("Label")
@export var label_toggle: bool = true :
	get(): return %SliderValueLabel.enabled
	set(value): %SliderValueLabel.enabled = value
@export_range(0, 2, 1, "or_greater") var decimals_padding: int = 0
@export var unit: String;
@export_category("Sound")
@export var slider_sound: AudioStream

var slider_value: float :
	get: return %HSlider.value
	set(_value): %HSlider.value = _value

func _get_configuration_warnings(): # Creates editor warnings 
	var msgs: PackedStringArray
	if (slider_value_changed.has_connections() != true && drag_ended.has_connections() != true):
		msgs.append("This component has no connections to any of its signals!")
	if slider_range_min == null || slider_range_max == null:
		msgs.append("Range values cannot be null!")
	if slider_range_max < slider_range_min:
		msgs.append("Slider max range must be more than min range!")
	if (slider_starting_value > slider_range_max || slider_starting_value < slider_range_min):
		msgs.append("The starting value is smaller or largest than the slider range!")
	if (slider_steps == 0):
		msgs.append("Slider cannot have 0 steps!")
	if (decimals_padding < 0):
		msgs.append("Decimal padding cannot be a negative value! ")
	return msgs


func _on_h_slider_value_changed(_slider_value: float) -> void:
	slider_value = _slider_value
	if (slider_value == 0 && zero_means_disabled == true):
		%SliderValueLabel.text = "Disabled"
	else:
		%SliderValueLabel.text = str(slider_value).pad_decimals(decimals_padding) + unit
	
	%SliderSoundEffect.play()
	slider_value_changed.emit(slider_value)


func _on_h_slider_drag_ended(_value_changed: bool) -> void:
	slider_value = %HSlider.value
	if (%HSlider.value == 0 && zero_means_disabled == true):
		%SliderValueLabel.text = "Disabled"
	else:
		%SliderValueLabel.text = str(%HSlider.value).pad_decimals(decimals_padding) + unit
	
	%SliderSoundEffect.play()
	drag_ended.emit(%HSlider.value)


func _ready() -> void:
	%HSlider.set_block_signals(true) # Block signals during initial setup, as min_value changes also trigger value_changed signal.
	
	## Do not shuffle order to avoid snapping to int.
	%HSlider.min_value = slider_range_min
	%HSlider.max_value = slider_range_max
	%HSlider.step = slider_steps
	%HSlider.value = slider_starting_value
	slider_value = slider_starting_value
	%HSlider.set_block_signals(false)
	
	%SliderValueLabel.text = str(slider_starting_value).pad_decimals(decimals_padding) + unit
	
	%SliderSoundEffect.stream = slider_sound

func reset_value() -> void:
	%HSlider.value = slider_starting_value

func reset_value_no_signal() -> void:
	%HSlider.set_value_no_signal(slider_starting_value)

func toggle_slider(toggle: bool) -> void:
	%HSlider.editable = toggle
