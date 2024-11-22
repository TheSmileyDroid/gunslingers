extends Node
class_name AttackComponent
@export var damage: int = 10
@export var fire_rate: float = 1.0
var can_attack: bool = true
var target = null

func _process(_delta):
	if can_attack and target:
		attack()
		can_attack = false
		await get_tree().create_timer(fire_rate).timeout
		can_attack = true

func attack():
	if target and target.is_inside_tree():
		target.get_node("HealthComponent").take_damage(damage)
