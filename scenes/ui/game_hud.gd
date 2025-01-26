extends Control

@onready var character_list_container: VBoxContainer = %CharacterList
@onready var panel_container: PanelContainer = %PanelContainer
@onready var cash_label: Label = %Cash

const CHARACTER_DATA_PATH = "res://data/characters/"

func _ready() -> void:
	Events.cash_changed.connect(on_cash_changed)
	Events.entered_game.connect(_on_entered_game)
	Events.exited_game.connect(_on_exited_game)
	Events.wave_started.connect(_on_wave_started)
	$PanelContainer/MarginContainer/VBoxContainer/Button.pressed.connect(_on_flip_button_pressed)
	_load_character_buttons()
	visible = false


func _process(_delta: float) -> void:
	pass

func _load_character_buttons() -> void:
	var dir = DirAccess.open(CHARACTER_DATA_PATH)
	if dir == null:
		printerr("Error opening directory:", CHARACTER_DATA_PATH)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	for child in character_list_container.get_children():
		character_list_container.remove_child(child)

	while file_name != "":
		if file_name.ends_with(".tres"):
			var character_button = preload("res://scenes/ui/shop_button.tscn").instantiate()

			var resource_path = CHARACTER_DATA_PATH + file_name
			var stats: CharacterData = load(resource_path)

			character_button.character_data = stats
			character_list_container.add_child(character_button)

		file_name = dir.get_next()

	dir.list_dir_end()

func _on_flip_button_pressed() -> void:
	var target_x = 0.0
	if panel_container.position.x == 0:
		target_x = get_viewport_rect().size.x - panel_container.size.x

	var tween = create_tween()
	tween.tween_property(panel_container, "position:x", target_x, 0.3) # Animate over 0.3 seconds
	tween.set_trans(Tween.TRANS_SINE) # Optional: Set the transition type
	tween.set_ease(Tween.EASE_IN_OUT) # Optional: Set the easing function

func on_cash_changed(cash: int):
	cash_label.text = "$%d" % cash # Using format for clarity

func _on_entered_game() -> void:
	visible = true

func _on_exited_game() -> void:
	visible = false

func _on_wave_started(wave: int) -> void:
	$Wave.text = "Onda %d" % wave
