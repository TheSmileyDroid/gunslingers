extends Area2D
class_name DetectionArea

var character: Character

var targets: Array = []


signal enemy_detected(character: Character)
signal enemy_lost(character: Character)

func _ready():
    character = get_parent()
    character.stats.changed.connect(_on_stats_changed)
    character.character_updated.connect(_on_character_updated)
    area_entered.connect(_on_area_entered)
    area_exited.connect(_on_area_exited)
    _on_stats_changed()

func _process(_delta: float) -> void:
    queue_redraw()

func _on_character_updated():
    if character.stats:
        character.stats.changed.disconnect(_on_stats_changed)
    character.stats.changed.connect(_on_stats_changed)
    _on_stats_changed()

func _on_stats_changed():
    $CollisionShape2D.shape = CircleShape2D.new()
    $CollisionShape2D.shape.radius = character.stats.attack_range

func _on_area_entered(area):
    if area is CollisionArea and area.character.team != character.team:
        targets.append(area.character)
        enemy_detected.emit(area.character)

func _on_area_exited(area):
    if area is CollisionArea and area.character.team != character.team:
        targets.erase(area.character)
        enemy_lost.emit(area.character)

func _draw() -> void:
    if GameInstance.debug_mode:
        draw_circle($CollisionShape2D.position, character.stats.attack_range, Color(1, 0, 0, 0.1))
