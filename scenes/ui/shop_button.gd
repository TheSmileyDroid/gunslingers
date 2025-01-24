extends Button
class_name ShopButton

signal character_data_changed

@export var character_data: CharacterData:
	set(value):
		character_data = value
		character_data_changed.emit()
		
		
func _ready() -> void:
	pressed.connect(_on_pressed)
	character_data_changed.connect(_on_character_data_changed)
	_on_character_data_changed()
	
func _on_character_data_changed() -> void:
	%TextureRect.texture = character_data.sprite_frames.get_frame_texture("idle", 0)
	%Price.text = "$%d" % character_data.price

func _on_pressed() -> void:
	Events.character_drag.emit(character_data.type)
