extends Control

func _ready() -> void:
	$VBoxContainer/ResumeButton.pressed.connect(resume)
	$VBoxContainer/RestartButton.pressed.connect(restart)
	$VBoxContainer/MenuButton.pressed.connect(go_to_menu)
	Events.unpaused_game.connect(hide)

func resume() -> void:
	Events.unpaused_game.emit()
	get_tree().paused = false


func restart() -> void:
	get_tree().paused = false
	Events.reset_game.emit()

func go_to_menu() -> void:
	get_tree().paused = false
	SceneManager.change_scene("res://scenes/main_menu.tscn")
	Events.exited_game.emit()
