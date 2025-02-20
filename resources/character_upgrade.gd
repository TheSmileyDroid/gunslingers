extends Resource
class_name CharacterUpgrade

@export var name: String = "Upgrade"
@export var description: String = ""
@export var cost: int = 100
@export_group("Stats Modifiers")
@export var health_bonus: int = 0
@export var damage_bonus: int = 0
@export var speed_bonus: float = 0.0
@export var fire_rate_bonus: float = 0.0
@export var range_bonus: float = 0.0
