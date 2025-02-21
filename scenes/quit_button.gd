extends GameButton

func _on_pressed() -> void:
	super._on_pressed()
	get_tree().quit()
