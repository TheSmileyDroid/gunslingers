extends ProgressBar
class_name HealthBar

var stats: CharacterData

func _ready():
	get_parent().character_updated.connect(_on_character_updated)
	_on_character_updated()

func _on_character_updated():
	if stats:
		stats.changed.disconnect(_stats_changed)
	stats = get_parent().stats
	max_value = stats.max_health
	value = stats.health
	stats.changed.connect(_stats_changed)

func _stats_changed():
	value = stats.health
	max_value = stats.max_health
