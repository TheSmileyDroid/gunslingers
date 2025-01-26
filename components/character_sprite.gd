extends AnimatedSprite2D
class_name CharacterSprite


var character: Character

var is_blinking = false
var blink_duration = 0.1


func _ready():
    character = get_parent()
    character.character_updated.connect(_on_character_updated)
    _on_character_updated()
    character.get_node("AttackComponent").attack_started.connect(on_attack_started)
    character.get_node("DetectionArea").enemy_detected.connect(on_enemy_detected)
    animation_finished.connect(_on_animation_finished)
    play("idle")
    character.get_node("HealthComponent").took_damage.connect(took_damage)

func took_damage():
    if !is_blinking:
        is_blinking = true
        start_blink()


func _on_animation_finished():
    if animation == "attack":
        play("idle")

func on_enemy_detected(_character: Character):
    var target = character.get_node("AttackComponent").get_target()
    if target:
        if target.global_position.x > global_position.x:
            flip_h = false
        else:
            flip_h = true


func on_attack_started(_character: Character):
    play("attack")


func _on_character_updated():
    if character.stats:
        sprite_frames = character.stats.sprite_frames


func start_blink():
    var tween = create_tween()
    tween.tween_property(material, "shader_parameter/blink_intensity", 10.0, blink_duration / 2.0) # Fade in
    tween.tween_property(material, "shader_parameter/blink_intensity", 1.0, blink_duration / 2.0) # Fade out
    tween.tween_callback(func(): is_blinking = false)
