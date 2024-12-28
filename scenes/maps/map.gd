extends Node2D
class_name Map

@export var map_data: MapData
@export var wave: int = 0
@export var cash: int:
    set(value):
        cash = value
        Events.cash_changed.emit(cash)
@export var lives: int

var placer: Sprite2D

func _ready() -> void:
    cash = map_data.initial_cash
    lives = map_data.initial_lives
    spawn_wave()
    Events.received_reward.connect(on_received_reward)
    Events.character_drag.connect(on_character_drag)
    Events.buy_character.connect(on_buy_character)
    placer = Sprite2D.new()
    placer.visible = false
    placer.scale.x = 3
    placer.scale.y = 3
    add_child(placer)

func spawn_wave() -> void:
    if wave >= map_data.waves:
        return
    wave += 1

func _input(event: InputEvent) -> void:
    if placer.visible and event is InputEventMouseMotion:
        placer.position = event.position


func on_received_reward(amount: int) -> void:
    cash += amount

func on_character_drag(character_type: String):
    if character_type != "":
        var character_data: CharacterData = load("res://data/characters/%s.tres" % character_type)
        var texture = character_data.sprite_frames.get_frame_texture("idle", 0)
        placer.texture = texture
        placer.visible = true
    else:
        placer.visible = false

func on_buy_character(character_id: String):
    var character_data: CharacterData = load("res://data/characters/%s.tres" % character_id)
    cash -= character_data.price