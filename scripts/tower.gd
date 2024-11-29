extends Area2D

@export var stats: CharacterStats
var health_component: HealthComponent
var attack_component: AttackComponent
var attack_range_component: AttackRangeComponent
@onready var hp_bar: ProgressBar = get_node("HPBar")

func _ready():
	add_to_group("gunslingers")
	health_component = get_node("HealthComponent")
	attack_component = get_node("AttackComponent")
	attack_range_component = get_node("AttackRangeComponent")
	health_component.max_health = stats.health
	attack_component.damage = stats.damage
	hp_bar.max_value = stats.health
	
	if not attack_range_component:
		area_entered.connect(_on_Gunslinger_body_entered)
		area_exited.connect(_on_Gunslinger_body_exited)
	if attack_range_component:
		attack_range_component.area2d.area_entered.connect(_on_Gunslinger_body_entered)
		attack_range_component.area2d.area_exited.connect(_on_Gunslinger_body_exited)


func _physics_process(_delta: float) -> void:
	hp_bar.value = health_component.current_health

func _on_Gunslinger_body_entered(body):
	print_debug("Range entered")
	if body.is_in_group("rats"):
		attack_component.targets.append(body)

func _on_Gunslinger_body_exited(body):
	print_debug("Range exited")
	if body.is_in_group("rats"):
		attack_component.targets.erase(body)
