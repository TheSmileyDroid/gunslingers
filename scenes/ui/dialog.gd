extends Control
class_name DialogSystem

signal dialog_finished

var dialog_data: DialogData
var current_line: int = 0

@onready var character_name: Label = $Panel/MarginContainer/VBoxContainer/CharacterName
@onready var text: Label = $Panel/MarginContainer/VBoxContainer/Text
@onready var left_character: AnimatedSprite2D = $LeftCharacter
@onready var right_character: AnimatedSprite2D = $RightCharacter

func start_dialog(data: DialogData) -> void:
	dialog_data = data
	current_line = 0
	visible = true
	show_line()

func show_line() -> void:
	if current_line >= dialog_data.lines.size():
		finish_dialog()
		return
		
	var line = dialog_data.lines[current_line]
	character_name.text = line.character_name
	text.text = line.text
	
	var character = left_character if line.position == DialogData.Position.LEFT else right_character
	var other_character = right_character if line.position == DialogData.Position.LEFT else left_character
	
	character.sprite_frames = line.sprite_frames
	character.play(line.animation)
	character.modulate = Color(1, 1, 1, 1)
	other_character.modulate = Color(0.5, 0.5, 0.5, 1)

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		current_line += 1
		show_line()

func finish_dialog() -> void:
	visible = false
	dialog_finished.emit()


func _ready() -> void:
	visible = false