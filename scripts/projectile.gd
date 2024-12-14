extends Node2D

var target: Node2D
@export var speed: float = 500.0
@export var damage: int = 10

func _physics_process(delta):
	if not target:
		queue_free()
		return
	if target and target.is_inside_tree():
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta

		rotation = direction.angle()

		if global_position.distance_to(target.global_position) < 10:
			target.get_node("HealthComponent").take_damage(damage)
			queue_free()
	else:
		queue_free()
