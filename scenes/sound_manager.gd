extends Node

@onready
var SFX: AudioStreamPlayer = get_node("%SFX")
@onready
var UI: AudioStreamPlayer = get_node("%UI")

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

var pentatonic_semitones: Array[int] = [0, 2, 4, 7, 9]


func _ready():
	SoundEvents.explosion.connect(_on_explode)
	SoundEvents.shoot.connect(_on_shoot)
	SoundEvents.melee_attack.connect(_on_melee_attack)
	SoundEvents.select_button.connect(_on_select_button)
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
