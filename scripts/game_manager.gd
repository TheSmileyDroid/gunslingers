extends Node

var selected_tower: String = ""
var level_instance: Node

func _ready():
	var current_level = GameInstance.save_data.current_level
	load_level(current_level)
	Events.tower_selected.connect(on_tower_selected)
	

func load_level(level):
	var level_scene = load("res://scenes/levels/%s.tscn" % level)
	level_instance = level_scene.instantiate()
	add_child(level_instance)
	Events.changed_level.emit(level)

func on_tower_selected(tower_id: String) -> void:
	selected_tower = tower_id

func _unhandled_input(event):
	if event is InputEventMouseButton and selected_tower != "":
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var tower = load("res://scenes/towers/%s.tscn" % selected_tower).instantiate()
			var mouse_pos = get_viewport().get_mouse_position()
			tower.position = mouse_pos
			level_instance.add_child(tower)
			selected_tower = ""
			Events.tower_selected.emit(selected_tower)
			Events.save_game.emit("autosave")
			Events.character_mouse_enter.emit(tower)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			selected_tower = ""
			Events.tower_selected.emit(selected_tower)
			Events.character_mouse_exit.emit(null)
			Events.save_game.emit("autosave")
			Events.character_mouse_exit.emit(null)
