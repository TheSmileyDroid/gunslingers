extends RichTextLabel


func _ready() -> void:
	Events.character_drag.connect(_on_character_drag)


func _on_character_drag(character_type: String) -> void:
	var data = CharacterData.get_character_data(character_type)
	if data == null:
		text = " "
		return
	text = data.name