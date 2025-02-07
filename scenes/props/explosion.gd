extends Node2D
class_name Explosion

var time_alive := 0.0
var size := 100
var damage := 10
var max_time_alive := 0.5
var team: Character.Team = Character.Team.ENEMY
@onready var area2d :Area2D = get_node("Area2D")
@onready var shape : CircleShape2D = get_node("Area2D").get_node("CollisionShape2D").shape
@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	if not area2d or not shape or not particles:
		push_error("Required nodes are missing!")
		return
	area2d.area_entered.connect(_on_area_entered)
	shape.radius = 0
	particles.lifetime = size / 200.0
	particles.emitting = true

	var tween = get_tree().create_tween()
	tween.tween_property(shape, "radius", size, max_time_alive).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(queue_free)

func _on_area_entered(area: Area2D) -> void:
	if is_queued_for_deletion():
		return
	if area.get_parent() is Character:
		var character: Character = area.get_parent() as Character
		var health_component = character.get_node_or_null("HealthComponent")
		if health_component and character.team != team:
			health_component.take_damage(damage, team)
