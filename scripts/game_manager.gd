extends Node


func _ready():
	var current_level = GameInstance.save_data.current_level
	load_level(current_level)
	

func load_level(level):
	var level_scene = load("res://scenes/levels/%s.tscn" % level)
	var level_instance = level_scene.instantiate()
	add_child(level_instance)
	Events.changed_level.emit(level)
