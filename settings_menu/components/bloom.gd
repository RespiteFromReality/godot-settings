extends Control

@onready var bloom_options: OptionButton = $BloomOptions


func _ready() -> void:
	var bloom: bool = Settings.graphics_get_bloom()
	var bicubic: bool = Settings.graphics_get_bloom_bicubic()
	bloom_options.set_block_signals(true)
	if bloom == true && bicubic == true:
		bloom_options.select(2)
	elif bloom == true && bicubic == false:
		bloom_options.select(1)
	else:
		bloom_options.select(0)
	bloom_options.set_block_signals(false)


func _on_bloom_options_item_selected(index: int) -> void:
	match index:
		0:
			Settings.graphics_set_bloom(false)
			Settings.graphics_set_bloom_bicubic(false)
		1:
			Settings.graphics_set_bloom(true)
			Settings.graphics_set_bloom_bicubic(false)
		2:
			Settings.graphics_set_bloom(true)
			Settings.graphics_set_bloom_bicubic(true)
