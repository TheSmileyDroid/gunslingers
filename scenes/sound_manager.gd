extends Node

@onready
var SFX: AudioStreamPlayer = get_node("%SFX")
@onready
var UI: AudioStreamPlayer = get_node("%UI")
@onready
var Music1: AudioStreamPlayer = get_node("%Music1")
@onready
var Music2: AudioStreamPlayer = get_node("%Music2")
@onready
var current_music: AudioStreamPlayer = Music1

var is_transitioning: bool = false

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
	"tema2": preload("res://assets/music/Tema 2.mp3"),
	"tema3": preload("res://assets/music/Tema 3.mp3"),
}

var is_writting: bool = false

var pentatonic_semitones: Array[int] = [0, 2, 4, 7, 9]


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
	SFX.stream = shoot_sounds[randi() % shoot_sounds.size()]
	_modify_pitch_scale()
	SFX.play()
	pass

func _on_melee_attack():
	SFX.stream = melee_attack_sounds[randi() % melee_attack_sounds.size()]
	_modify_pitch_scale()
	SFX.play()
	pass

func _modify_pitch_scale():
	SFX.pitch_scale = 1.0
	var x: int = pentatonic_semitones[randi() % pentatonic_semitones.size()]
	for i in range(0, x):
		SFX.pitch_scale *= 1.0594630943592953
	pass

func _on_explode():
	SFX.stream = explosion_sounds[randi() % explosion_sounds.size()]
	SFX.pitch_scale = 0.8 + randf() * 0.4
	SFX.play()
	pass

func _on_select_button():
	UI.stream = select_button_sounds[randi() % select_button_sounds.size()]
	UI.play()
	pass

func start_writting():
	if is_writting:
		return
	is_writting = true
	UI.stream = writting_sfx[randi() % writting_sfx.size()]
	UI.play()
	pass

func _process(_delta):
	if is_writting and not UI.is_playing():
		UI.stream = writting_sfx[randi() % writting_sfx.size()]
		UI.play()

func _on_play_music(music_name: String):
	print("play music: ", music_name)
	await get_tree().create_timer(0.0).timeout
	if not musics.has(music_name):
		print("Music not found: ", music_name)
		return
	if is_transitioning:
		print("Music is transitioning")
		return
	if current_music.stream == musics[music_name] and current_music.playing:
		return
	is_transitioning = true
	var next_music: AudioStreamPlayer = Music1 if current_music == Music2 else Music2
	next_music.stream = musics[music_name]
	var volume = current_music.volume_db
	next_music.volume_db = -80
	next_music.play()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(current_music, "volume_db", -80,
		1.0).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(next_music, "volume_db",
		volume, 2.0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(_on_music_transition_finished).set_delay(1)

func _on_music_transition_finished():
	current_music.stop()
	current_music = Music1 if current_music == Music2 else Music2
	is_transitioning = false
