extends Button


func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	SoundEvents.select_button.emit()
	GameManager.load_level("test")
