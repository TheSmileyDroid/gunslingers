extends Resource
class_name DialogData

enum Position {LEFT, RIGHT}


@export var lines: Array[DialogLine]

static func create_line(character_name: String, text: String, sprite_frames: SpriteFrames, position: Position = Position.LEFT, animation: String = "talk") -> DialogLine:
    var line = DialogLine.new()
    line.character_name = character_name
    line.text = text
    line.sprite_frames = sprite_frames
    line.position = position
    line.animation = animation
    return line
