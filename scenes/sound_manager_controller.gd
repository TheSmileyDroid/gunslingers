extends Node

var explosion_sounds: Array[AudioStream] = [
	preload("res://assets/sfx/explosion-1.ogg"),
	preload("res://assets/sfx/explosion-2.ogg"),
	preload("res://assets/sfx/explosion-3.ogg"),
]

var shoot_sounds: Array[AudioStream] = [
	preload("res://assets/sfx/gun-1.ogg"),
	preload("res://assets/sfx/gun-2.ogg"),
	preload("res://assets/sfx/gun-3.ogg")
]

var melee_attack_sounds: Array[AudioStream] = [
	preload("res://assets/sfx/impact-1.ogg"),
]

var select_button_sounds: Array[AudioStream] = [
	preload("res://assets/sfx/ui/Modern10.ogg"),
	preload("res://assets/sfx/ui/Modern11.ogg"),
	preload("res://assets/sfx/ui/Modern12.ogg"),
]

var writting_sfx: Array[AudioStream] = [
	preload("res://assets/sfx/ui/Modern13.ogg"),
	preload("res://assets/sfx/ui/Modern14.ogg"),
	preload("res://assets/sfx/ui/Modern15.ogg"),
]

var musics = {
	"tema": preload("res://assets/music/Tema principal.mp3"),
	"tema1": preload("res://assets/music/Tema principal (variação).mp3"),
	"tema2": preload("res://assets/music/Tema 2.mp3"),
	"tema3": preload("res://assets/music/Tema 2 - variação.mp3"),
	"tema4": preload("res://assets/music/Tema 3.mp3"),
	"tema5": preload("res://assets/music/Tema 4.mp3"),
}

var is_writting: bool = false

var pentatonic_semitones: Array[int] = [0, 2, 4, 7, 9]

var changing_music: bool = false

func _ready():
	SoundEvents.explosion.connect(_on_explode)
	SoundEvents.shoot.connect(_on_shoot)
	SoundEvents.melee_attack.connect(_on_melee_attack)
	SoundEvents.select_button.connect(_on_select_button)
	SoundEvents.writting.connect(start_writting)
	SoundEvents.stop_writting.connect(func(): is_writting = false)
	SoundEvents.play_music.connect(_on_play_music)
	pass

func _on_shoot():
	var stream = shoot_sounds[randi() % shoot_sounds.size()]
	var pitch = _modify_pitch_scale()
	SoundManager.play_sound_with_pitch(stream, pitch)
	pass

func _on_melee_attack():
	var stream = melee_attack_sounds[randi() % melee_attack_sounds.size()]
	var pitch = _modify_pitch_scale()
	SoundManager.play_sound_with_pitch(stream, pitch)
	pass

func _modify_pitch_scale():
	var pitch_scale = 1.0
	var x: int = pentatonic_semitones[randi() % pentatonic_semitones.size()]
	for i in range(0, x):
		pitch_scale *= 1.0594630943592953
	return pitch_scale

func _on_explode():
	var stream = explosion_sounds[randi() % explosion_sounds.size()]
	var pitch = 0.8 + randf() * 0.4
	SoundManager.play_sound_with_pitch(stream, pitch)
	pass

func _on_select_button():
	var stream = select_button_sounds[randi() % select_button_sounds.size()]
	SoundManager.play_ui_sound(stream)
	pass

func start_writting():
	if is_writting:
		return
	is_writting = true
	var stream = writting_sfx[randi() % writting_sfx.size()]
	SoundManager.play_ui_sound(stream)
	pass

func _on_play_music(music_name: String):
	changing_music = true
	print("play music: ", music_name)
	await get_tree().create_timer(0.0).timeout
	if not musics.has(music_name):
		print("Music not found: ", music_name)
		return
	var player := SoundManager.play_music(musics[music_name], 2.0)
	changing_music = false
	await player.finished
	if not changing_music:
		_on_play_music(music_name)
	pass
