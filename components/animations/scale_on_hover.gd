extends Node
class_name ScaleOnHover

@export var anim_duration := 0.2
@export var scaling := 1.1
@onready var btn: Button = get_parent() as Button

func _ready() -> void:
    if btn:
        btn.mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered() -> void:
    var tw = create_tween()
    tw.tween_property(btn, "scale", scaling, anim_duration)
    tw.set_ease(Tween.EASE_IN_OUT)
    tw.set_trans(Tween.TRANS_CUBIC)
    tw.play()