extends Control

func _ready():
	var settings = GameInstance.settings
	%MusicSlider.value = settings.music_volume
	%SoundSlider.value = settings.sound_volume
	%FullscreenCheck.button_pressed = settings.fullscreen

	%MusicSlider.value_changed.connect(_on_music_slider_value_changed)
	%SoundSlider.value_changed.connect(_on_sound_slider_value_changed)
	%FullscreenCheck.toggled.connect(_on_fullscreen_toggled)

func _on_music_slider_value_changed(value: float) -> void:
	SoundManager.set_music_volume(value)
	GameInstance.settings.music_volume = value
	GameInstance.save_settings()

func _on_sound_slider_value_changed(value: float) -> void:
	SoundManager.set_sound_volume(value)
	GameInstance.settings.sound_volume = value
	GameInstance.save_settings()

func _on_fullscreen_toggled(button_pressed: bool) -> void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	GameInstance.settings.fullscreen = button_pressed
	GameInstance.save_settings()
