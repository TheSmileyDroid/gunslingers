extends PanelContainer

@onready var stats_label: Label = %StatsLabel
var following: bool = false
var offset = Vector2(10, 10)

func _ready() -> void:
	Events.character_selected.connect(_on_character_selected)
	Events.character_deselected.connect(_on_character_deselected)
	visible = false

func _process(_delta: float) -> void:
	if following:
		global_position = get_viewport().get_mouse_position() + offset

func _on_character_selected(character: Character) -> void:
	stats_label.text = character.stats.to_display_string()
	visible = true
	following = true

func _on_character_deselected() -> void:
	visible = false
	following = false
