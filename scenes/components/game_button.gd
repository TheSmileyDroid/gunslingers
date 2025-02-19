@tool
extends Button
class_name GameButton

@onready
var button_shader: ColorRect = preload("res://components/animations/shine.tscn").duplicate().instantiate()

func _ready() -> void:
	add_child(button_shader)
	pressed.connect(_on_pressed)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)


func _on_pressed() -> void:
	SoundEvents.select_button.emit()


func _on_mouse_entered() -> void:
	button_shader.shine()


func _on_mouse_exited() -> void:
	pass
