extends Resource
class_name CharacterStats
@export var health: int = 100: set = set_health
@export var max_health: int = 100: set = set_max_health
@export var damage: int = 10: set = set_damage
@export var speed: float = 100.0: set = set_speed
@export var cooldown: float = 0.5: set = set_cooldown
@export var strategy: AttackComponent.Strategy = AttackComponent.Strategy.first: set = set_strategy

func set_health(value: int) -> void:
    health = clamp(value, 0, max_health)
    changed.emit()

func set_max_health(value: int) -> void:
    max_health = max(1, value)
    changed.emit()

func set_damage(value: int) -> void:
    damage = max(1, value)
    changed.emit()

func set_speed(value: float) -> void:
    speed = max(0.0, value)
    changed.emit()

func set_cooldown(value: float) -> void:
    cooldown = max(0.0, value)
    changed.emit()

func set_strategy(value: AttackComponent.Strategy) -> void:
    strategy = value
    changed.emit()

func _display_strategy(t_strategy: AttackComponent.Strategy) -> String:
    match t_strategy:
        AttackComponent.Strategy.first:
            return tr("First")
        AttackComponent.Strategy.last:
            return tr("Last")
        AttackComponent.Strategy.strongest:
            return tr("Strongest")
        AttackComponent.Strategy.weakest:
            return tr("Weakest")
        
    return tr("Unknown")

func to_display_string() -> String:
    return tr("Health: {health}/{max_health}\nDamage: {damage}\nSpeed: {speed}\nCooldown: {cooldown}\nStrategy: {strategy}").format({
        "health": health,
        "max_health": max_health,
        "damage": damage,
        "speed": speed,
        "cooldown": cooldown,
        "strategy": _display_strategy(strategy)
    })