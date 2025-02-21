extends Node

var selected_character: String = ""
var in_game: bool = false:
	set(value):
		in_game = value
		if value == false:
			SoundEvents.play_music.emit("tema")
var loaded_level: String = "":
	set(value):
		loaded_level = value
		loaded_level_changed.emit(value)
		if loaded_level == "test":
			SoundEvents.play_music.emit("tema1")
		if loaded_level == "02_village_map":
			SoundEvents.play_music.emit("tema3")
		if loaded_level == "03_desert_map":
			SoundEvents.play_music.emit("tema2")
		if loaded_level == "04_ruins_city_map":
			SoundEvents.play_music.emit("tema1")
		if loaded_level == "05_abandoned_mine_map":
			SoundEvents.play_music.emit("tema3")
var hovering_character: Character = null
var show_health_bars: bool = false

var is_playing: bool = false

signal loaded_level_changed(level: String)

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

	await get_tree().create_timer(0.0).timeout
	SoundEvents.play_music.emit("tema")


func _entered_game():
	in_game = true

func _on_exited_game():
	in_game = false
	get_tree().paused = false

func load_level(level):
	print("Loading level: %s" % level)
	await SceneManager.change_scene(("res://scenes/maps/%s.tscn" % level), {
		"pattern": "scribbles"
	})
	Events.changed_level.emit(level)
	Events.entered_game.emit()
	loaded_level = level

func _reset_game():
	print("Resetting game")
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

	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	if event.is_action_pressed("printscreen"):
		var texture := get_viewport().get_texture()
		var screenshot := texture.get_image()
		var resizedImage = Image.new()
		var scaleFactor: int = int(1920 / get_viewport().size.x)

		var resizedWidth: int = get_viewport().size.x * scaleFactor
		var resizedHeight: int = get_viewport().size.y * scaleFactor

		resizedImage = Image.create(resizedWidth, resizedHeight, false, Image.FORMAT_BPTC_RGBA)
		screenshot.resize(resizedWidth, resizedHeight, Image.INTERPOLATE_NEAREST)
		resizedImage.blit_rect(screenshot, Rect2(Vector2.ZERO, screenshot.get_size()), Vector2.ZERO)
		var date = Time.get_datetime_string_from_system().replace(".", "_").replace(":", "_")
		print("Saving screenshot to: %s" % OS.get_user_data_dir() + "/screenshots/screenshot_%s.png" % date)
		DirAccess.make_dir_recursive_absolute(OS.get_user_data_dir() + "/screenshots")
		screenshot.save_png(OS.get_user_data_dir() + "/screenshots/screenshot_%s.png" % date)
	if event.is_action_pressed("open_user_data"):
		OS.shell_open(OS.get_user_data_dir())

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
