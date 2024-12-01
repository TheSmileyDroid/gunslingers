extends Node
class_name HealthComponent

var stats: CharacterStats

func take_damage(amount: int):
    stats.health -= amount
    if stats.health <= 0:
        die()

func die():
    get_parent().queue_free()