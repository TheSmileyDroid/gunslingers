extends Node

var selected_character: String = ""
var in_game: bool = false
var loaded_level: String = ""
var hovering_character: Character = null
var show_health_bars: bool = false

func _ready():
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	Events.character_drag.connect(on_character_selected)
	Events.entered_game.connect(_entered_game)
	Events.reset_game.connect(_reset_game)
	Events.won_game.connect(_on_win_game)
	Events.character_mouse_enter.connect(_on_character_mouse_enter)
	Events.character_mouse_exit.connect(_on_character_mouse_exit)
	Events.player_died.connect(_on_player_died)
	Events.exited_game.connect(_on_exited_game)

func _entered_game():
	in_game = true

func _on_exited_game():
	in_game = false
	get_tree().paused = false

func load_level(level):
	await SceneManager.change_scene(("res://scenes/maps/%s.tscn" % level), {
		"pattern": "scribbles"
	})
	Events.changed_level.emit(level)
	Events.entered_game.emit()
	loaded_level = level

func _reset_game():
	if loaded_level != "":
		load_level(loaded_level)

func on_character_selected(character_id: String) -> void:
	selected_character = character_id

func _unhandled_input(event):
	if event is InputEventMouseButton and selected_character != "":
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_character(selected_character, get_viewport().get_mouse_position())
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			selected_character = ""
			Events.character_drag.emit("")

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and hovering_character != null:
		Events.character_selected.emit(hovering_character)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and hovering_character == null:
		Events.character_deselected.emit()

func _input(event: InputEvent) -> void:
	if in_game:
		if event.is_action_pressed("pause"):
			
			get_tree().paused = !get_tree().paused
			if get_tree().paused:
				Events.paused_game.emit()
			else:
				Events.unpaused_game.emit()
		if event.is_action_pressed("toggle_health_bar"):
			show_health_bars = !show_health_bars
			Events.show_health_bars.emit(show_health_bars)


func spawn_character(character_id: String, position: Vector2):
	var stats: CharacterData = load("res://data/characters/%s.tres" % character_id).duplicate()
	var has_money = stats.price <= get_tree().current_scene.cash
	var is_overlapping = len(get_tree().current_scene.placer.overlapping) > 0
	if is_overlapping or !has_money:
		return
	var character = preload("res://scenes/characters/character.tscn").instantiate()
	character.stats = stats
	character.position = position
	get_tree().current_scene.add_child(character)
	Events.buy_character.emit(character_id)
	selected_character = ""
	Events.character_drag.emit("")


func spawn_enemy(enemy_id: String, position: Vector2) -> Character:
	var enemy = preload("res://scenes/enemies/enemy.tscn").instantiate()
	enemy.stats = load("res://data/enemies/%s.tres" % enemy_id).duplicate()
	enemy.position = position
	get_tree().current_scene.add_child(enemy)
	return enemy

func _on_win_game() -> void:
	get_tree().paused = true

func _on_character_mouse_enter(character: Character) -> void:
	hovering_character = character

func _on_character_mouse_exit(character: Character) -> void:
	if hovering_character == character:
		hovering_character = null

func _on_player_died() -> void:
	get_tree().paused = true
	Ui.get_node("%LoseScreen").show()
