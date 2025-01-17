extends Node

var selected_character: String = ""

func _ready():
	Events.character_drag.connect(on_character_selected)

func load_level(level):
	await SceneManager.change_scene(("res://scenes/maps/%s.tscn" % level), {
		"pattern": "squares"
	})
	Events.changed_level.emit(level)

func on_character_selected(character_id: String) -> void:
	selected_character = character_id

func _unhandled_input(event):
	if event is InputEventMouseButton and selected_character != "":
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_character(selected_character, get_viewport().get_mouse_position())
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			selected_character = ""
			Events.character_drag.emit("")


func spawn_character(character_id: String, position: Vector2):
	var stats: CharacterData = load("res://data/characters/%s.tres" % character_id).duplicate()
	var has_money = stats.price <= get_tree().current_scene.cash
	var is_overlapping = len(get_tree().current_scene.placer.overlapping) > 0
	print_debug("Cash: %s" % get_tree().current_scene.cash + "  Price: %s" % stats.price)
	if is_overlapping or !has_money:
		return
	var character = preload("res://scenes/characters/character.tscn").instantiate()
	character.stats = stats
	character.position = position
	get_tree().current_scene.add_child(character)
	Events.buy_character.emit(character_id)
	selected_character = ""
	Events.character_drag.emit("")
	

func spawn_enemy(enemy_id: String, position: Vector2):
	var enemy = preload("res://scenes/enemies/enemy.tscn").instantiate()
	enemy.stats = load("res://data/enemies/%s.tres" % enemy_id).duplicate()
	enemy.position = position
	get_tree().current_scene.add_child(enemy)
