extends Resource
class_name CharacterData


@export var name: String = "Character"
@export var price: int = 100
@export var sprite_frames: SpriteFrames = load("res://assets/heroes/base_melee.tres")

@export var health: int = 100: set = set_health
@export var max_health: int = 100: set = set_max_health
@export var damage: int = 10: set = set_damage
@export var speed: float = 100.0: set = set_speed
@export var fire_rate: float = 0.5: set = set_fire_rate
@export var pierce: int = 1
@export var strategy: AttackComponent.Strategy = AttackComponent.Strategy.first: set = set_strategy
@export var attack_range: float = 100.0: set = set_range
var type: String:
	get():
		return resource_path.get_file().get_basename()

enum AttackType {melee, ranged, heal}

@export var attack_type: AttackType = AttackType.melee

@export var size: int = 2:
	set(value):
		size = max(1, value)
		changed.emit()

@export var reward: int = 10:
	set(value):
		reward = max(0, value)
		changed.emit()

func set_health(value: int) -> void:
	health = value
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

func set_fire_rate(value: float) -> void:
	fire_rate = max(0.0, value)
	changed.emit()

func set_strategy(value: AttackComponent.Strategy) -> void:
	strategy = value
	changed.emit()

func set_range(value: float) -> void:
	attack_range = max(0.0, value)
	changed.emit()

func _init() -> void:
	pass

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
		AttackComponent.Strategy.nearest:
			return tr("Closest")
		AttackComponent.Strategy.farthest:
			return tr("Farthest")

	return tr("Unknown")

func to_display_string() -> String:
	return tr("Health: {health} / {max_health} \nDamage: {damage}\nSpeed: {speed}\nFire Rate: {fire_rate}\nStrategy: {strategy}").format({
		"health": health,
		"max_health": max_health,
		"damage": damage,
		"speed": speed,
		"fire_rate": fire_rate,
		"strategy": _display_strategy(strategy)
	})

static func get_character_data(character_type: String) -> CharacterData:
	if len(character_type) == 0 or character_type == " ":
		return null
	var _resource_path = "res://data/characters/%s.tres" % character_type
	return load(_resource_path) as CharacterData


@export var on_death_effects: Array[TriggerEffect] = []

@export var projectile: PackedScene = null
