extends Control


@onready var shadow_resolution_options: OptionButton = $ShadowResolutionOptions
@onready var shadow_filtering_options: OptionButton = $ShadowFilteringOptions


func _ready() -> void:
	var resolution: int = Settings.graphics_get_shadow_resolution_directional()
	shadow_resolution_options.set_block_signals(true)
	match resolution:
		256: shadow_resolution_options.select(0)
		512: shadow_resolution_options.select(1)
		1024: shadow_resolution_options.select(2)
		2048: shadow_resolution_options.select(3)
		4096: shadow_resolution_options.select(4)
		8192: shadow_resolution_options.select(5)
	shadow_resolution_options.set_block_signals(false)
	
	var filtering: RenderingServer.ShadowQuality = Settings.graphics_get_shadow_filtering_directional()
	shadow_filtering_options.set_block_signals(true)
	shadow_filtering_options.select(filtering)
	shadow_filtering_options.set_block_signals(false)


func _on_shadow_resolution_options_item_selected(index: int) -> void:
	match index:
		0:
			Settings.graphics_set_shadow_resolution_directional(256)
			Settings.graphics_set_shadow_resolution_positional(0)
		1:
			Settings.graphics_set_shadow_resolution_directional(512)
			Settings.graphics_set_shadow_resolution_positional(512)
			#directional_light.shadow_bias = 0.04
		2:
			Settings.graphics_set_shadow_resolution_directional(1024)
			Settings.graphics_set_shadow_resolution_positional(1024)
			#directional_light.shadow_bias = 0.03
		3:
			Settings.graphics_set_shadow_resolution_directional(2048)
			Settings.graphics_set_shadow_resolution_positional(2048)
			#directional_light.shadow_bias = 0.02
		4:
			Settings.graphics_set_shadow_resolution_directional(4096)
			Settings.graphics_set_shadow_resolution_positional(4096)
			#directional_light.shadow_bias = 0.01
		5:
			Settings.graphics_set_shadow_resolution_directional(8192)
			Settings.graphics_set_shadow_resolution_positional(8192)
			#directional_light.shadow_bias = 0.005


func _on_shadow_filtering_options_item_selected(index: int) -> void:
	match index:
		0: 
			Settings.graphics_set_shadow_filtering_directional(RenderingServer.SHADOW_QUALITY_HARD)
			Settings.graphics_set_shadow_filtering_positional(RenderingServer.SHADOW_QUALITY_HARD)
		1:
			Settings.graphics_set_shadow_filtering_directional(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
			Settings.graphics_set_shadow_filtering_positional(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
		2:
			Settings.graphics_set_shadow_filtering_directional(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
			Settings.graphics_set_shadow_filtering_positional(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		3:
			Settings.graphics_set_shadow_filtering_directional(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
			Settings.graphics_set_shadow_filtering_positional(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		4:
			Settings.graphics_set_shadow_filtering_directional(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
			Settings.graphics_set_shadow_filtering_positional(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		5:
			Settings.graphics_set_shadow_filtering_directional(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
			Settings.graphics_set_shadow_filtering_positional(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
