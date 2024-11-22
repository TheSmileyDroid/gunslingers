extends Area2D

@export var stats: CharacterStats
var health_component: HealthComponent
var attack_component: AttackComponent
@onready var hp_bar: ProgressBar = get_node("HPBar")

func _ready():
	add_to_group("gunslingers")
	health_component = get_node("HealthComponent")
	attack_component = get_node("AttackComponent")
	health_component.max_health = stats.health
	attack_component.damage = stats.damage
	hp_bar.max_value = stats.health
	
	area_entered.connect(_on_Gunslinger_body_entered)
	area_exited.connect(_on_Gunslinger_body_exited)

func _physics_process(_delta: float) -> void:
	hp_bar.value = health_component.current_health

func _on_Gunslinger_body_entered(body):
	if body.is_in_group("rats"):
		print("Rat entered tower's area")
		attack_component.target = body

func _on_Gunslinger_body_exited(body):
	if body.is_in_group("rats"):
		print("Rat exited tower's area")
		attack_component.target = null
