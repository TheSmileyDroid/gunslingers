extends Node

var selected_tower: String = ""
var level_instance: Map

func _ready():
	Events.character_drag.connect(on_tower_selected)
	if get_tree().current_scene is Map:
		level_instance = get_tree().current_scene

func load_level(level):
	get_tree().change_scene("res://scenes/maps/%s.tscn" % level)
	Events.changed_level.emit(level)

func on_tower_selected(tower_id: String) -> void:
	selected_tower = tower_id

func _unhandled_input(event):
	if event is InputEventMouseButton and selected_tower != "":
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_character(selected_tower, get_viewport().get_mouse_position())
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			selected_tower = ""
			Events.character_drag.emit("")


func spawn_character(character_id: String, position: Vector2):
	#TODO: Check if is occupied
	var character = preload("res://scenes/characters/character.tscn").instantiate()
	character.stats = load("res://data/characters/%s.tres" % character_id).duplicate()
	character.position = position
	level_instance.add_child(character)
	Events.buy_character.emit(character_id)
	selected_tower = ""
	Events.character_drag.emit("")
	

func spawn_enemy(enemy_id: String, position: Vector2):
	var enemy = preload("res://scenes/enemies/enemy.tscn").instantiate()
	enemy.stats = load("res://data/enemies/%s.tres" % enemy_id).duplicate()
	enemy.position = position
	level_instance.add_child(enemy)
