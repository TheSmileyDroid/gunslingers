extends PanelContainer

func _ready() -> void:
	visible = false
	Events.character_mouse_enter.connect(_display_character_info)
	Events.character_mouse_exit.connect(_handle_mouse_exit)
	

func _display_character_info(character: Character) -> void:
	position = get_viewport().get_mouse_position()
	visible = true
	
	var label: Label = get_node("MarginContainer/Label")
	label.text = character.stats.to_display_string()
	

func _handle_mouse_exit(_character: Character) -> void:
	visible = false
