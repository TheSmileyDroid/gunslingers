extends Node

var save_data: SaveData
var settings: SettingsData

var debug_mode: bool = false
var debug_font: Font = preload("res://assets/debug.tres")

func _ready():
	save_data = load_game()
	if not save_data:
		save_data = SaveData.new()
		save_data.name = "Player"
		save_data.current_level = "test"
		save_data.money = 0
		save_data.time_played = 0.0
		save_game()
	Events.save_game.connect(save_game)
	Events.load_game.connect(load_game)

	settings = load_settings()
	if not settings:
		settings = SettingsData.new()
		save_settings()
	apply_settings()

func save_game(save_name: String = "savegame") -> void:
	var error := ResourceSaver.save(save_data, "user://%s.res" % save_name)
	if error != OK:
		print("Error saving game: ", error)
	else:
		print("Game saved")

func load_game(save_name: String = "savegame") -> SaveData:
	var save = load("user://%s.res" % save_name)
	if save:
		save_data = save
		print("Game loaded")
		return save_data
	else:
		print("No save file found")
		return null

func save_settings() -> void:
	var error := ResourceSaver.save(settings, "user://settings.res")
	if error != OK:
		print("Error saving settings: ", error)
	else:
		print("Settings saved")

func load_settings() -> SettingsData:
	var settings = load("user://settings.res") as SettingsData
	if settings:
		print("Settings loaded")
		return settings
	else:
		print("No settings file found")
		return null

func apply_settings() -> void:
	if settings:
		SoundManager.set_music_volume(settings.music_volume)
		SoundManager.set_sound_volume(settings.sound_volume)
		if settings.fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_mode"):
		debug_mode = !debug_mode
