extends Timer
class_name FireRateComponent

var character: Character


func _ready():
	character = get_parent()
	character.character_updated.connect(_on_character_updated)
	autostart = true
	_on_character_updated()
	timeout.connect(character.get_node("AttackComponent").attack)
	start()

func _on_character_updated():
	wait_time = 10.0 / character.stats.fire_rate
