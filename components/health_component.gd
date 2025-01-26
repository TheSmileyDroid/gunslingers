extends Node
class_name HealthComponent

var stats: CharacterData

signal took_damage

func _ready():
	get_parent().character_updated.connect(_on_character_updated)
	_on_character_updated()

func _on_character_updated():
	stats = get_parent().stats

func take_damage(amount: int, source_team: Character.Team):
	stats.health -= amount
	took_damage.emit()
	if stats.health <= 0:
		if source_team == Character.Team.PLAYER:
			Events.received_reward.emit(stats.reward)
		die()

func heal(amount: int):
	stats.health += amount
	if stats.health > stats.max_health:
		stats.health = stats.max_health
	get_parent().get_node("HealParticles").emitting = true

func die():
	Events.character_died.emit(get_parent())
	get_parent().queue_free()
