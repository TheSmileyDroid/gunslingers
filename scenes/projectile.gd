extends Node2D

var target: Character
var speed: float = 700.0
var damage: int = 10
var lifetime: float = 1.0
var source_team: Character.Team
var source: Character:
	set(value):
		source = value
		source_team = source.team

var hits: Array[Character] = []
var max_hits: int = 1
var hits_count: int = 0
var direction = Vector2.ZERO

func _physics_process(delta):
	if is_instance_valid(target):
		direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()
	position += direction * speed * delta


func _ready():
	direction = (target.global_position - global_position).normalized()
	rotation = direction.angle()
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _on_area_2d_area_exited(_area: Area2D) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is CollisionArea and !is_queued_for_deletion():
		var character: Character = area.get_parent()
		if !is_instance_valid(character):
			return
		if character not in hits and character.team != source_team:
			hits.append(character)
			hits_count += 1
			character.get_node("HealthComponent").take_damage(damage, source_team)
			if hits_count >= max_hits:
				queue_free()
				return
