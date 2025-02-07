extends Control

@export var shortcut: String = "" :
	set(value):
		shortcut = value
		if is_node_ready() and get_node("%Label"):
			get_node("%Label").text = value
		else:
			print("No label found")

@export var icon: Texture = null :
	set(value):
		icon = value
		if is_node_ready() and get_node("%Icon"):
			get_node("%Icon").texture = value
		else:
			print("No icon found")

func _ready() -> void:
	if icon:
		%Icon.texture = icon
	if shortcut:
		%Label.text = shortcut 	