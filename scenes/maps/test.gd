extends Map

func _play_cutscene() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		GameManager.spawn_enemy("rat", get_viewport().get_mouse_position())
	pass
