extends Control

func _ready() -> void:
	$VBoxContainer/RestartButton.pressed.connect(restart)
	$VBoxContainer/MenuButton.pressed.connect(go_to_menu)

func restart() -> void:
	Events.reset_game.emit()
	hide()

func go_to_menu() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn", {
		"pattern": "scribbles"
	})
	Events.exited_game.emit()
	hide()
