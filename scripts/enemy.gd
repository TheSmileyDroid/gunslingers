extends Character

var path = null
var path_index: int = 0

func _ready():
	add_to_group("rats")
	super()
	if get_parent().has_node("Path2D"):
		path = get_parent().get_node("Path2D").curve

func _physics_process(delta):
	super._physics_process(delta)
	move_along_path(delta)

func move_along_path(delta):
	if len(attack_component.targets) > 0:
		return
	if path and path_index < path.get_point_count():
		var point = path.get_point_position(path_index)
		var direction = (point - global_position).normalized()
		position += direction * stats.speed * delta
		if global_position.distance_to(point) < 10:
			path_index += 1
	else:
		reach_end()

func reach_end():
	if path:
		queue_free()

func _on_area_entered(body):
	if body.is_in_group("gunslingers"):
		attack_component.targets.append(body)

func _on_area_exited(body):
	if body.is_in_group("gunslingers"):
		attack_component.targets.erase(body)
