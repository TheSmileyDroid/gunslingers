extends Control

func _ready() -> void:
	$VBoxContainer/RestartButton.pressed.connect(restart)
	$VBoxContainer/MenuButton.pressed.connect(go_to_menu)

func restart() -> void:
	get_tree().paused = false
	Events.reset_game.emit()
	hide()

func go_to_menu() -> void:
	get_tree().paused = false
	SceneManager.change_scene("res://scenes/main_menu.tscn")
	Events.exited_game.emit()
	hide()
