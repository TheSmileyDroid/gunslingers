extends Button


func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	SceneManager.change_scene("res://scenes/maps/test.tscn", {
		"pattern": "squares"
	})