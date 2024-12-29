extends Control

var tower_list_container: VBoxContainer

func _ready() -> void:
	Events.cash_changed.connect(on_cash_changed)

	# get from res://data/characters/
	var dir = DirAccess.open("res://data/characters/")
	dir.list_dir_begin()
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".tres"):
				var character_button = Button.new()
				character_button.custom_minimum_size = Vector2(0, 64)
				var stats: CharacterData = load("res://data/characters/%s" % file_name)
				character_button.text = stats.name + "\n" + "$" + str(stats.price)
				character_button.pressed.connect(on_tower_pressed.bind(file_name.replace(".tres", "")))
				%CharacterList.add_child(character_button)
			file_name = dir.get_next()
			
		dir.list_dir_end()

func on_tower_pressed(tower_id: String) -> void:
	Events.character_drag.emit(tower_id)


func _on__flip_button_pressed() -> void:
	if %PanelContainer.position.x == 0:
		%PanelContainer.position.x = get_viewport_rect().size.x - %PanelContainer.size.x
		print(get_viewport_rect().size.x - %PanelContainer.size.x)
	else:
		%PanelContainer.position.x = 0

func on_cash_changed(cash: int):
	%Cash.text = "$" + str(cash)
