extends AnimatedSprite2D
class_name CharacterSprite

var character: Character


func _ready():
    character = get_parent()
    character.character_updated.connect(_on_character_updated)
    _on_character_updated()
    character.get_node("AttackComponent").attack_started.connect(on_attack_started)
    character.get_node("DetectionArea").enemy_detected.connect(on_enemy_detected)
    animation_finished.connect(_on_animation_finished)
    play("idle")

func _on_animation_finished():
    if animation == "attack":
        character.get_node("AttackComponent").finish_attack()
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
    sprite_frames = character.stats.sprite_frames
