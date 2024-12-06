extends Node
class_name HealthComponent

var stats: CharacterStats

var animation_player: AnimationPlayer

func _ready():
    animation_player = get_parent().get_node("AnimationPlayer")

func take_damage(amount: int):
    stats.health -= amount
    if animation_player:
        animation_player.play("hit")
    if stats.health <= 0:
        die()

func die():
    get_parent().queue_free()