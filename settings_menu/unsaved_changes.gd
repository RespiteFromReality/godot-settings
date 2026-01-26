extends ConfirmationDialog

@onready var exit_btn: Button = $"../Exit"


func _ready() -> void:
	exit_btn.unsaved_changes.connect(draw)


func draw() -> void:
	self.visible = true


func call_close() -> void:
	exit_btn.close()


func _on_confirmed() -> void:
	SettingsFiles.save_config(SettingsFiles.user_config)
	call_close()


func _on_canceled() -> void:
	SettingsFiles.load_or_create_settings_file()
	Settings.load_settings()
	call_close()
