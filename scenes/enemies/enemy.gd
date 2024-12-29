extends Character
class_name Rat

var path = null
var path_index: int = 0

signal has_reached_end(damage: int)

func _ready():
	if get_parent().has_node("Path2D"):
		path = get_parent().get_node("Path2D").curve

func _physics_process(delta):
	super._physics_process(delta)
	move_along_path(delta)

func move_along_path(delta):
	if len($DetectionArea.targets) > 0 or $CharacterSprite.animation != "idle":
		return
	if path and path_index < path.get_point_count():
		var point = path.get_point_position(path_index)
		var direction = (point - global_position).normalized()
		position += direction * stats.speed * delta
		if direction.x < 0:
			get_node("CharacterSprite").flip_h = true
		else:
			get_node("CharacterSprite").flip_h = false

		if global_position.distance_to(point) < 10:
			path_index += 1
	else:
		reach_end()

func reach_end():
	has_reached_end.emit(stats.damage)
	if path:
		queue_free()
