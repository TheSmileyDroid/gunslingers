extends Node
class_name HealthComponent

var stats: CharacterData

signal took_damage

func _ready():
	get_parent().character_updated.connect(_on_character_updated)
	_on_character_updated()

func _on_character_updated():
	stats = get_parent().stats

func take_damage(amount: int, source: Character):
	stats.health -= amount
	took_damage.emit()
	if stats.health <= 0:
		if source.team == Character.Team.PLAYER:
			Events.received_reward.emit(stats.reward)
		die()

func die():
	get_parent().queue_free()
