extends Node
class_name HealthComponent
@export var max_health: int = 100
var current_health: int

func _ready():
    current_health = max_health

func take_damage(amount: int):
    current_health -= amount
    if current_health <= 0:
        die()

func die():
    get_parent().queue_free()