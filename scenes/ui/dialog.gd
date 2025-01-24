extends Control
class_name DialogSystem

signal dialog_finished

var dialog_data: DialogData
var current_line: int = 0
var full_text: String = ""
var text_index: int = 0
var is_text_completed: bool = true

@onready var character_name: Label = $Panel/MarginContainer/VBoxContainer/CharacterName
@onready var text: Label = $Panel/MarginContainer/VBoxContainer/Text
@onready var left_character: AnimatedSprite2D = $LeftCharacter
@onready var right_character: AnimatedSprite2D = $RightCharacter
@onready var background: TextureRect = $TextureRect
@onready var text_timer: Timer = Timer.new()

func _ready() -> void:
	visible = false
	add_child(text_timer)
	text_timer.timeout.connect(_on_text_timer_timeout)
	text_timer.wait_time = 0.05

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
	full_text = line.text
	text.text = ""
	text_index = 0
	is_text_completed = false
	background.texture = line.background
	
	var character = left_character if line.position == DialogData.Position.LEFT else right_character
	var other_character = right_character if line.position == DialogData.Position.LEFT else left_character
	
	character.sprite_frames = line.sprite_frames
	character.play(line.animation)
	character.modulate = Color(1, 1, 1, 1)
	other_character.modulate = Color(0.5, 0.5, 0.5, 1)
	
	text_timer.start()

func _on_text_timer_timeout() -> void:
	if text_index < full_text.length():
		text.text += full_text[text_index]
		text_index += 1
	else:
		text_timer.stop()
		is_text_completed = true

func _input(event: InputEvent) -> void:
	if not visible:
		return
		
	if event.is_action_pressed("ui_accept"):
		if is_text_completed:
			current_line += 1
			show_line()
		else:
			# Skip text animation
			text.text = full_text
			text_timer.stop()
			is_text_completed = true

func finish_dialog() -> void:
	visible = false
	dialog_finished.emit()