extends Area2D

@export var stats: CharacterStats
var health_component: HealthComponent
var attack_component: AttackComponent
var path = null
var path_index: int = 0
var blocked_path = false
@onready var hp_bar: ProgressBar = get_node("HP")

func _ready():
	add_to_group("rats")
	health_component = get_node("HealthComponent")
	attack_component = get_node("AttackComponent")
	health_component.max_health = stats.health
	hp_bar.max_value = stats.health
	attack_component.damage = stats.damage
	area_entered.connect(_on_Rat_body_entered)
	area_exited.connect(_on_Rat_body_exited)
	if get_parent().has_node("Path2D"):
		path = get_parent().get_node("Path2D").curve

func _physics_process(delta):
	hp_bar.value = health_component.current_health
	move_along_path(delta)

func move_along_path(delta):
	if blocked_path:
		return
	if path and path_index < path.get_point_count():
		var point = path.get_point_position(path_index)
		var direction = (point - global_position).normalized()
		position += direction * stats.speed * delta
		if global_position.distance_to(point) < 50:
			path_index += 1
	else:
		reach_end()

func reach_end():
	if path:
		queue_free()

func _on_Rat_body_entered(body):
	if body.is_in_group("gunslingers"):
		print("Tower entered rat's area")
		attack_component.target = body
		blocked_path = true

func _on_Rat_body_exited(body):
	if body.is_in_group("gunslingers"):
		print("Tower exited rat's area")
		attack_component.target = null