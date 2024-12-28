extends Timer
class_name FireRateComponent

var character: Character


func _ready():
	character = get_parent()
	character.character_updated.connect(_on_character_updated)
	one_shot = true
	_on_character_updated()

func _on_character_updated():
	wait_time = 1.0 / character.stats.fire_rate