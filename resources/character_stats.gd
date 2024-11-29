extends Resource
class_name CharacterStats
@export var health: int = 100
@export var damage: int = 10
@export var speed: float = 100.0
@export var fire_rate: float = 1.0
@export var strategy: AttackComponent.Strategy = AttackComponent.Strategy.first