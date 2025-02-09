extends Button

@export_file var go_to_scene: String = "res://scenes/maps.tscn"

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	SoundEvents.select_button.emit()
	SceneManager.change_scene(go_to_scene, {
		"pattern": "scribbles",
		"transition": "fade",
		"duration": 1.0
	})
