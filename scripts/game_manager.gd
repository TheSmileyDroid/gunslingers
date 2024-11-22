extends Node

var current_level = "test"

func _ready():
	load_level(current_level)

func load_level(level):
	var level_scene = load("res://scenes/levels/%s.tscn" % level)
	var level_instance = level_scene.instantiate()
	add_child(level_instance)
