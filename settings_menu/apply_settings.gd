extends Control


func _on_pressed() -> void:
	SettingsFiles.save_config(SettingsFiles.user_config)
