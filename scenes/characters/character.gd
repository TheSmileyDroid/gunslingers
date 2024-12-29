extends Node2D
class_name Character


signal character_updated(character: Character)

@export var stats: CharacterData:
	set(value):
		stats = value
		character_updated.emit(self)

enum Team {PLAYER, ENEMY}

@export var team: Team:
	set(value):
		team = value
		remove_from_group("enemy" if value == Team.PLAYER else "player")
		add_to_group("player" if value == Team.PLAYER else "enemy")
		character_updated.emit(self)
		
func _physics_process(_delta: float) -> void:
	if GameInstance.debug_mode:
		queue_redraw()

func _draw() -> void:
	if GameInstance.debug_mode:
		var red: float = 1.0 if team == Team.ENEMY else 0.0
		var blue: float = 1.0 if team == Team.PLAYER else 0.0
		@warning_ignore("int_as_enum_without_cast")
		draw_string(GameInstance.debug_font, Vector2(0, -20), stats.name + " - " + name, 0, -1, 12, Color(red, 0.0, blue, 1.0))

func _on_area_entered(_body):
	pass

func _on_area_exited(_body):
	pass

func _mouse_enter() -> void:
	Events.character_mouse_enter.emit(self)

func _mouse_exit() -> void:
	Events.character_mouse_exit.emit(self)
