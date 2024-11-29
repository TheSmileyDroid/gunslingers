extends Area2D
class_name Character

@export var stats: CharacterStats
var health_component: HealthComponent
var attack_component: AttackComponent
var attack_range_component: AttackRangeComponent
var hp_bar: ProgressBar

func _ready():
    if has_node("HealthComponent"):
        health_component = get_node("HealthComponent")
        health_component.max_health = stats.health
    if has_node("HPBar"):
        hp_bar = get_node("HPBar")
        hp_bar.max_value = stats.health
    if has_node("AttackComponent"):
        attack_component = get_node("AttackComponent")
        attack_component.damage = stats.damage
        attack_component.fire_rate = stats.fire_rate
        attack_component.strategy = stats.strategy
    if has_node("AttackRangeComponent"):
        attack_range_component = get_node("AttackRangeComponent")
        attack_range_component.area2d.area_entered.connect(_on_area_entered)
        attack_range_component.area2d.area_exited.connect(_on_area_exited)
    else:
        if has_signal("area_entered"):
            area_entered.connect(_on_area_entered)
        if has_signal("area_exited"):
            area_exited.connect(_on_area_exited)

func _physics_process(_delta):
    if health_component and hp_bar:
        hp_bar.value = health_component.current_health

func _on_area_entered(_body):
    pass

func _on_area_exited(_body):
    pass