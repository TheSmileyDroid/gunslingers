@tool
extends Control

@export var shortcut: String = "":
	set(value):
		shortcut = value
		if is_node_ready() and get_node("%Label"):
			get_node("%Label").text = value
		else:
			set_deferred("%Label.text", value)

@export var icon: Texture = null:
	set(value):
		icon = value
		if is_node_ready() and get_node("%Icon"):
			get_node("%Icon").texture = value
		else:
			set_deferred("%Icon.texture", value)

func _ready() -> void:
	if icon:
		get_node("%Icon").texture = icon
	if shortcut:
		get_node("%Label").text = shortcut
