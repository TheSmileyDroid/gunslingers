extends Control

var tower_list_container: VBoxContainer
var tower_list: Array

func _ready() -> void:
	tower_list_container = $PanelContainer/MarginContainer/ScrollContainer/MarginContainer/Towers

	# get from scene/towers
	tower_list = []
	var dir = DirAccess.open("res://scenes/towers")
	dir.list_dir_begin()
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".tscn"):
				tower_list.append("res://scenes/towers/" + file_name)
				var tower_scene = Button.new()
				tower_scene.custom_minimum_size = Vector2(0, 64)
				var tower_id = file_name.replace(".tscn", "")
				tower_scene.text = tower_id
				tower_scene.pressed.connect(on_tower_pressed.bind(tower_id))
				tower_list_container.add_child(tower_scene)
			file_name = dir.get_next()
			
		dir.list_dir_end()

func on_tower_pressed(tower_id: String) -> void:
	Events.tower_selected.emit(tower_id)


func _on__flip_button_pressed() -> void:
	if $PanelContainer.position.x == 0:
		$PanelContainer.position.x = get_viewport_rect().size.x - $PanelContainer.size.x
		print(get_viewport_rect().size.x - $PanelContainer.size.x)
	else:
		$PanelContainer.position.x = 0
