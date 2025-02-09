extends Node

@onready
var SFX: AudioStreamPlayer = get_node("%SFX")

var explosion_sounds: Array[AudioStream] = [
	preload("res://assets/sfx/explosion1.wav"),
]

var select_button_sounds: Array[AudioStream] = [
	preload("res://assets/sfx/select.wav"),
]

var pentatonic_semitones: Array[int] = [0, 2, 4, 7, 9]


func _ready():
	SoundEvents.explosion.connect(_on_explode)
	SoundEvents.select_button.connect(_on_select_button)
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
	SFX.stream = select_button_sounds[randi() % select_button_sounds.size()]
	SFX.play()
	pass
