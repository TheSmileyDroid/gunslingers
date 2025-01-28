extends Node2D
class_name Explosion

var time_alive := 0.0
var size := 100
var damage := 10
var max_time_alive := 0.5
var team: Character.Team = Character.Team.ENEMY
@onready var area2d :Area2D = get_node("Area2D")
@onready var shape : CircleShape2D = get_node("Area2D").get_node("CollisionShape2D").shape

func _ready() -> void:
	area2d.area_entered.connect(_on_area_entered)
	shape.radius = 0
	$GPUParticles2D.lifetime = size / 200.0
	$GPUParticles2D.emitting = true

	var tween = get_tree().create_tween()
	tween.tween_property(shape, "radius", size, max_time_alive).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(queue_free)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Character:
		var character: Character = area.get_parent() as Character
		if character.team != team:
			character.get_node("HealthComponent").take_damage(damage, team)
