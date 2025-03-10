extends Area2D
class_name CollisionArea

var character: Character

var targets: Array = []


func _ready():
	character = get_parent()
	character.character_updated.connect(_on_character_updated)
	_on_stats_changed()


func _process(_delta: float) -> void:
	queue_redraw()

func _on_character_updated():
	if character.stats:
		character.stats.changed.disconnect(_on_stats_changed)
	character.stats.changed.connect(_on_stats_changed)
	_on_stats_changed()

func _on_stats_changed():
	if is_queued_for_deletion() or $CollisionShape2D.is_queued_for_deletion():
		return
	$CollisionShape2D.shape = CircleShape2D.new()
	$CollisionShape2D.shape.radius = character.stats.size * 4

func _draw() -> void:
	if GameInstance.debug_mode:
		draw_circle($CollisionShape2D.position, character.stats.size * 4, Color(0, 0, 1, 0.1))
