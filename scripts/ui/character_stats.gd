extends PanelContainer

var character: Character


func _ready() -> void:
	visible = false
	Events.character_mouse_enter.connect(_display_character_info)
	Events.character_mouse_exit.connect(_handle_mouse_exit)
	

func _display_character_info(t_character: Character) -> void:
	position = get_viewport().get_mouse_position()
	visible = true

	if character:
		character.stats.changed.disconnect(_handle_changes)
	character = t_character
	_handle_changes()
	t_character.stats.changed.connect(_handle_changes)

func _handle_mouse_exit(_character: Character) -> void:
	visible = false

func _handle_changes() -> void:
	var label: Label = get_node("MarginContainer/Label")
	label.text = character.stats.to_display_string()