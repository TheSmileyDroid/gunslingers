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
        health_component.stats = stats
    if has_node("HPBar"):
        hp_bar = get_node("HPBar")
        hp_bar.max_value = stats.max_health
        print(stats.health)
        hp_bar.value = stats.health
    if has_node("AttackComponent"):
        attack_component = get_node("AttackComponent")
        attack_component.stats = stats
    if has_node("AttackRangeComponent"):
        attack_range_component = get_node("AttackRangeComponent")
        attack_range_component.stats = stats
        attack_range_component.area2d.area_entered.connect(_on_area_entered)
        attack_range_component.area2d.area_exited.connect(_on_area_exited)
    else:
        if has_signal("area_entered"):
            area_entered.connect(_on_area_entered)
        if has_signal("area_exited"):
            area_exited.connect(_on_area_exited)
    stats.changed.connect(_stats_changed)

func _stats_changed():
    hp_bar.value = stats.health
    hp_bar.max_value = stats.max_health
        

func _physics_process(_delta: float) -> void:
    pass

func _on_area_entered(_body):
    pass

func _on_area_exited(_body):
    pass

func _mouse_enter() -> void:
    Events.character_mouse_enter.emit(self)

func _mouse_exit() -> void:
    Events.character_mouse_exit.emit(self)