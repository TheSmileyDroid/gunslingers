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
var curve: Curve2D
var time_elapsed: float = 0.0


func _physics_process(delta):
	time_elapsed += delta
	var ratio = time_elapsed / lifetime
	if ratio >= 1.0:
		queue_free()
		return

	var baked := curve.sample_baked_with_rotation(ratio * curve.get_baked_length(), true)

	global_position = baked.get_origin()
	rotation = baked.get_rotation()

	if is_instance_valid(target) and not target in hits:
		pass


func _ready():
	curve = Curve2D.new()
	var p1 = global_position
	var in_p1 = Vector2(0, 0)
	var out_p1 = Vector2(global_position.x, global_position.y - 50) - p1
	var p2 = target.global_position
	var in_p2 = Vector2(target.global_position.x, target.global_position.y - 50) - p2
	var out_p2 = Vector2(0, 0)
	curve.add_point(p1, in_p1, out_p1)
	curve.add_point(p2, in_p2, out_p2)


func _on_area_2d_area_exited(_area: Area2D) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	var ratio = time_elapsed / lifetime
	if area is CollisionArea and !is_queued_for_deletion() and ratio >= 0.7:
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
