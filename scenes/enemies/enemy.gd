extends Character
class_name Rat

var path = null
var path_index: int = 0

func _ready():
	if get_parent().has_node("Path2D"):
		path = get_parent().get_node("Path2D").curve
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	move_along_path(delta)

func move_along_path(delta):
	if $AttackComponent.get_target() != null or $CharacterSprite.animation != "idle":
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
	Events.enemy_has_reached_goal.emit(self)
	if path:
		Events.character_died.emit(self)
		queue_free()
