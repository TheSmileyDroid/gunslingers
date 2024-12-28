extends Node2D

var target: Character
var speed: float = 700.0
var damage: int = 10
var lifetime: float = 1.0
var source: Character
var hits: Array[Character] = []
var max_hits: int = 1
var hits_count: int = 0
var direction = Vector2.ZERO

func _physics_process(delta):
	position += direction * speed * delta
	
		
func _ready():
	direction = (target.global_position - global_position).normalized()
	rotation = direction.angle()
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _on_area_2d_area_exited(_area: Area2D) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is CollisionArea:
		var character: Character = area.get_parent()
		if character not in hits and character.team != source.team:
			hits.append(character)
			hits_count += 1
			character.get_node("HealthComponent").take_damage(damage, source)
			if hits_count >= max_hits:
				queue_free()
				return
