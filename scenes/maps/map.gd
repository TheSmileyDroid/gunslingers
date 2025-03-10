extends Node2D
class_name Map

@export
var map_data: MapData

@export var wave: int = 0
@export var cash: int:
	set(value):
		cash = value
		Events.cash_changed.emit(cash)
@export var lives: int:
	set(value):
		lives = value
		Events.lives_changed.emit(lives)
		if lives <= 0:
			Events.player_died.emit()

@export var difficulty: Curve

@warning_ignore("unused_parameter")
func _play_cutscene() -> void:
	pass

var placer: Node2D
var dragging_character_data: CharacterData

var current_wave: WaveData
var spawn_timer: Timer
var enemies_to_spawn: Array[CharacterData] = []

var alive_enemies: Array[Character] = []

var can_spawn_wave: bool = true


func _ready() -> void:
	GameManager.loaded_level = map_data.name
	get_tree().paused = false
	Events.entered_game.emit()
	cash = map_data.initial_cash
	lives = map_data.initial_lives

	spawn_timer = Timer.new()
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(spawn_enemy)
	add_child(spawn_timer)

	if map_data.initial_dialog != null:
		await show_dialog(map_data.initial_dialog)

	_play_cutscene()
	Events.is_wave_spawnable.emit(true)
	Events.received_reward.connect(on_received_reward)
	Events.character_drag.connect(on_character_drag)
	Events.buy_character.connect(on_buy_character)
	Events.character_died.connect(_on_enemy_death)
	Events.next_wave.connect(spawn_wave)
	placer = preload("res://scenes/placer.tscn").instantiate()
	placer.visible = false
	add_child(placer)

	Events.enemy_has_reached_goal.connect(_on_enemy_reached_end)


func spawn_wave() -> void:
	wave += 1
	print("Wave ", wave, "/", len(map_data.waves))
	if map_data.name == "05_abandoned_mine_map" and wave == 4:
		SoundEvents.play_music.emit("tema5")

	if wave > len(map_data.waves):
		if map_data.name == "05_abandoned_mine_map":
			SoundEvents.play_music.emit("tema6")
			await show_dialog(map_data.victory_dialog)
			Events.exited_game.emit()
			SceneManager.change_scene("res://scenes/credits.tscn")
			return
		if map_data.victory_dialog != null:
			await show_dialog(map_data.victory_dialog)
		Events.won_game.emit()
		return
	can_spawn_wave = false

	current_wave = map_data.waves[wave - 1]

	Events.wave_started.emit(wave)

	if current_wave.initial_dialog != null:
		await show_dialog(current_wave.initial_dialog)

	var count = current_wave.count
	enemies_to_spawn = []
	for i in count:
		enemies_to_spawn.append_array(current_wave.enemies.duplicate())
	spawn_timer.start(current_wave.spawn_rate)

func spawn_enemy() -> void:
	if enemies_to_spawn.is_empty():
		return

	var enemy_data = enemies_to_spawn.pop_front()
	var path2d: Path2D = get_node("Path2D")
	var enemy_instance = GameManager.spawn_enemy(enemy_data.type, path2d.curve.get_point_position(0))
	alive_enemies.append(enemy_instance)


func _on_enemy_death(enemy: Character):
	alive_enemies.erase(enemy)
	if alive_enemies.is_empty() and enemies_to_spawn.is_empty():
		if map_data.name == "05_abandoned_mine_map":
				SoundEvents.play_music.emit("tema6")
		if current_wave.victory_dialog != null:
			await show_dialog(current_wave.victory_dialog)
	if alive_enemies.is_empty() and enemies_to_spawn.is_empty():
		if wave > len(map_data.waves):
			if map_data.name == "05_abandoned_mine_map":
				SoundEvents.play_music.emit("tema6")
				SceneManager.change_scene("res://scenes/credits.tscn")
			Events.won_game.emit()
		else:
			Events.is_wave_spawnable.emit(true)


func show_dialog(dialog_path: DialogData) -> void:
	await Ui.start_dialog(dialog_path)

func _input(event: InputEvent) -> void:
	if !is_instance_valid(placer):
		return
	if placer.visible and event is InputEventMouseMotion:
		placer.position = event.position


func on_received_reward(amount: int) -> void:
	cash += amount

func on_character_drag(character_type: String):
	if character_type != "":
		dragging_character_data = load("res://data/characters/%s.tres" % character_type)
		var texture = dragging_character_data.sprite_frames.get_frame_texture("idle", 0)
		placer.get_node("Sprite2D").texture = texture
		placer.get_node("Area2D/CollisionShape2D").shape.radius = dragging_character_data.size * 4
		placer.attack_range = dragging_character_data.attack_range
		placer.visible = true
	else:
		placer.visible = false

func on_buy_character(character_id: String):
	var character_data: CharacterData = load("res://data/characters/%s.tres" % character_id)
	cash -= character_data.price

func _on_enemy_reached_end(enemy: Character) -> void:
	lives -= enemy.stats.damage
