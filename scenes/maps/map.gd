extends Node2D
class_name Map

@export
var map_data: MapData

@export var wave: int = 0
@export var cash: int:
    set(value):
        cash = value
        Events.cash_changed.emit(cash)
@export var lives: int

@export var difficulty: Curve

@warning_ignore("unused_parameter")
func _play_cutscene() -> void:
    pass

var placer: Node2D
var dragging_character_data: CharacterData

var current_wave: WaveData
var spawn_timer: Timer
var enemies_to_spawn: Array[CharacterData] = []

func _ready() -> void:
    cash = map_data.initial_cash
    lives = map_data.initial_lives
    
    spawn_timer = Timer.new()
    spawn_timer.one_shot = false
    spawn_timer.timeout.connect(spawn_enemy)
    add_child(spawn_timer)

    if map_data.initial_dialog != null:
        await show_dialog(map_data.initial_dialog)
    
    _play_cutscene()
    spawn_wave()
    Events.received_reward.connect(on_received_reward)
    Events.character_drag.connect(on_character_drag)
    Events.buy_character.connect(on_buy_character)
    placer = preload("res://scenes/placer.tscn").instantiate()
    placer.visible = false
    add_child(placer)
    

func spawn_wave() -> void:
    if wave >= len(map_data.waves):
        return
        
    current_wave = map_data.waves[wave]
    wave += 1
    
    if current_wave.initial_dialog != null:
        await show_dialog(current_wave.initial_dialog)
    
    enemies_to_spawn = current_wave.enemies.duplicate()
    spawn_timer.start(current_wave.spawn_rate)

func spawn_enemy() -> void:
    if enemies_to_spawn.is_empty():
        spawn_timer.stop()
        if current_wave.victory_dialog != null:
            await show_dialog(current_wave.victory_dialog)
        spawn_wave()
        return
         
    var enemy_data = enemies_to_spawn.pop_front()
    var path2d: Path2D = get_node("Path2D")
    GameManager.spawn_enemy(enemy_data.type, path2d.curve.get_point_position(0))

func show_dialog(dialog_path: DialogData) -> void:
    await Ui.start_dialog(dialog_path)

func _input(event: InputEvent) -> void:
    if placer.visible and event is InputEventMouseMotion:
        placer.position = event.position
        

func on_received_reward(amount: int) -> void:
    cash += amount

func on_character_drag(character_type: String):
    if character_type != "":
        dragging_character_data = load("res://data/characters/%s.tres" % character_type)
        var texture = dragging_character_data.sprite_frames.get_frame_texture("idle", 0)
        placer.get_node("Sprite2D").texture = texture
        placer.get_node("Area2D/CollisionShape2D").shape.radius = dragging_character_data.size * 10
        placer.attack_range = dragging_character_data.attack_range
        placer.visible = true
    else:
        placer.visible = false

func on_buy_character(character_id: String):
    var character_data: CharacterData = load("res://data/characters/%s.tres" % character_id)
    cash -= character_data.price