extends ProgressBar
class_name HealthBar

var stats: CharacterData

func _ready():
	get_parent().character_updated.connect(_on_character_updated)
	_on_character_updated()
	visible = false

func _on_character_updated():
	if !visible:
		return
	if stats:
		stats.changed.disconnect(_stats_changed)
	stats = get_parent().stats
	if stats:
		max_value = stats.max_health
		value = stats.health
		stats.changed.connect(_stats_changed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_health_bar"):
		visible = !visible
		if visible:
			_on_character_updated()
			_stats_changed()

func _stats_changed():
	if !visible:
		return
	value = stats.health
	max_value = stats.max_health
