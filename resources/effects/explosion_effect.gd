extends TriggerEffect
class_name ExplosionEffect

@export var size: int = 100
@export var damage: int = 10

var explosion: PackedScene = preload("res://scenes/props/explosion.tscn")

func trigger_effect(character: Character) -> void:
    var explosion_instance: Explosion = explosion.instantiate()
    explosion_instance.global_position = character.global_position
    explosion_instance.size = size
    explosion_instance.damage = damage
    explosion_instance.team = character.team
    character.get_parent().add_child(explosion_instance)
