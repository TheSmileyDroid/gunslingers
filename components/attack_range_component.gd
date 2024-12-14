extends Node2D
class_name AttackRangeComponent


var stats: CharacterStats: set = set_stats
var area2d: Area2D = Area2D.new()


func _ready():
    add_child(area2d)

func set_stats(value: CharacterStats) -> void:
    if stats:
        stats.changed.disconnect(_resize)
    stats = value
    if value:
        var collision = CollisionShape2D.new()
        var shape = CircleShape2D.new()
        shape.radius = stats.attack_range
        collision.shape = shape
        area2d.add_child(collision)

        stats.changed.connect(_resize)


func _resize():
    area2d.get_child(0).shape.radius = stats.attack_range