extends Button

@onready var settings_menu: Control = $".."

signal unsaved_changes;

func _on_pressed() -> void:
	if SettingsFiles.unsaved_changes != true:
		close()
	else:
		unsaved_changes.emit()


func close() -> void:
	settings_menu.visible = false
	settings_menu.queue_free()
