extends Control

@onready var character_list_container: VBoxContainer = %CharacterList
@onready var panel_container: PanelContainer = %Shop
@onready var cash_label: Label = %Cash
@onready var lives_label: Label = %Lives
@onready var wave_label: Label = %Wave

@export var characters: Array[CharacterData] = []
@export var test_characters: Array[CharacterData] = []
@export var village_characters: Array[CharacterData] = []
@export var desert_characters: Array[CharacterData] = []
@export var ruins_city_characters: Array[CharacterData] = []
@export var abandoned_mine_characters: Array[CharacterData] = []


func _ready() -> void:
	Events.cash_changed.connect(update_cash)
	Events.lives_changed.connect(update_lives)
	Events.wave_started.connect(update_wave)
	Events.entered_game.connect(_on_entered_game)
	Events.exited_game.connect(_on_exited_game)
	GameManager.loaded_level_changed.connect(_changed_level)
	_load_character_buttons()
	visible = false

func _changed_level(level: String) -> void:
	var characters_per_level: Dictionary = {
		"test": test_characters,
		"02_village_map": village_characters,
		"03_desert_map": desert_characters,
		"04_ruins_city_map": ruins_city_characters,
		"05_abandoned_mine_map": abandoned_mine_characters
	}
	characters = characters_per_level[level]
	_load_character_buttons()

func _process(_delta: float) -> void:
	pass

func _load_character_buttons() -> void:
	for child in character_list_container.get_children():
		character_list_container.remove_child(child)

	for character in characters:
		var character_button = preload("res://scenes/ui/shop_button.tscn").instantiate()

		var stats: CharacterData = character

		character_button.character_data = stats
		character_list_container.add_child(character_button)

func _on_flip_button_pressed() -> void:
	var target_x = 0.0
	if panel_container.position.x == 0:
		target_x = get_viewport_rect().size.x - panel_container.size.x

	var tween = create_tween()
	tween.tween_property(panel_container, "position:x", target_x, 0.3) # Animate over 0.3 seconds
	tween.set_trans(Tween.TRANS_SINE) # Optional: Set the transition type
	tween.set_ease(Tween.EASE_IN_OUT) # Optional: Set the easing function

func update_cash(amount: int) -> void:
	cash_label.text = "$%s" % str(amount)

func update_lives(lives: int) -> void:
	lives_label.text = "♥ %s" % str(lives)

func update_wave(wave: int) -> void:
	wave_label.text = "Wave %d" % wave

func _on_entered_game() -> void:
	visible = true

func _on_exited_game() -> void:
	visible = false

func _on_wave_started(wave: int) -> void:
	$Wave.text = "Onda %d" % wave
