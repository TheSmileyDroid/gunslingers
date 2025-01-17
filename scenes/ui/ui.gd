extends Control

@onready var character_list_container: VBoxContainer = %CharacterList
@onready var panel_container: PanelContainer = %PanelContainer
@onready var cash_label: Label = %Cash

const CHARACTER_DATA_PATH = "res://data/characters/"

func _ready() -> void:
	Events.cash_changed.connect(on_cash_changed)
	Events.entered_game.connect(_on_entered_game)
	Events.exited_game.connect(_on_exited_game)
	_load_character_buttons()

func _load_character_buttons() -> void:
	var dir = DirAccess.open(CHARACTER_DATA_PATH)
	if dir == null:
		printerr("Error opening directory:", CHARACTER_DATA_PATH)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tres"):
			var character_button = Button.new()
			character_button.custom_minimum_size = Vector2(0, 64)

			var resource_path = CHARACTER_DATA_PATH + file_name
			var stats: CharacterData = load(resource_path)

			if stats:
				character_button.text = "%s\n$%d" % [stats.name, stats.price] # Using format for clarity
				var tower_id = file_name.get_basename() # More direct way to get the ID
				character_button.pressed.connect(on_tower_pressed.bind(tower_id))
				character_list_container.add_child(character_button)
			else:
				printerr("Error loading character data:", resource_path)

		file_name = dir.get_next()

	dir.list_dir_end()

func on_tower_pressed(tower_id: String) -> void:
	Events.character_drag.emit(tower_id)

func _on__flip_button_pressed() -> void:
	var target_x = 0.0
	if panel_container.position.x == 0:
		target_x = get_viewport_rect().size.x - panel_container.size.x

	var tween = create_tween()
	tween.tween_property(panel_container, "position:x", target_x, 0.3) # Animate over 0.3 seconds
	tween.set_trans(Tween.TRANS_SINE) # Optional: Set the transition type
	tween.set_ease(Tween.EASE_IN_OUT) # Optional: Set the easing function

func on_cash_changed(cash: int):
	cash_label.text = "$%d" % cash # Using format for clarity

func _on_entered_game() -> void:
	%GameHUD.visible = true

func _on_exited_game() -> void:
	%GameHUD.visible = false