extends Node2D

var rat_scene := preload("res://scenes/enemies/rat.tscn")

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var rat = rat_scene.instantiate()
		add_child(rat)
		rat.position = get_viewport_rect().size / 2
		rat.position.x = 0
	pass
