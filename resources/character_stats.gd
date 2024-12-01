extends Resource
class_name CharacterStats
@export var health: int = 100
@export var damage: int = 10
@export var speed: float = 100.0
@export var cooldown: float = 0.5
@export var strategy: AttackComponent.Strategy = AttackComponent.Strategy.first

func _display_strategy(t_strategy: AttackComponent.Strategy) -> String:
    match t_strategy:
        AttackComponent.Strategy.first:
            return "First"
        AttackComponent.Strategy.last:
            return "Last"
        AttackComponent.Strategy.strongest:
            return "Strongest"
        AttackComponent.Strategy.weakest:
            return "Weakest"
        
    return "Unknown"

func to_display_string() -> String:
    return "Health: {health}\nDamage: {damage}\nSpeed: {speed}\nCooldown: {cooldown}\nStrategy: {strategy}".format({
        "health": health,
        "damage": damage,
        "speed": speed,
        "cooldown": cooldown,
        "strategy": _display_strategy(strategy)
    })