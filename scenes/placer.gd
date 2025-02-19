extends Node2D
class_name Placer

var attack_range: int = 0

var overlapping: Array[Area2D] = []

func _ready() -> void:
	$Area2D.area_entered.connect(_on_area_entered)
	$Area2D.area_exited.connect(_on_area_exited)

func _physics_process(_delta: float) -> void:
	if visible:
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, attack_range, Color(0.2, 0.2, 0.8, 0.4))

func _on_area_entered(area):
	if area:
		overlapping.append(area)
	if len(overlapping) > 0:
		modulate = Color(8, 1, 1, 1)
	else:
		modulate = Color(1, 1, 1, 1)

func _on_area_exited(area):
	if area:
		overlapping.erase(area)
	if len(overlapping) > 0:
		modulate = Color(8, 1, 1, 1)
	else:
		modulate = Color(1, 1, 1, 1)
