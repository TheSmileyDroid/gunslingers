extends Label


var texts = [
	"Procura-se um Salvador!",
	"Ratos me Mordam!",
	"Essa cidade é pequena demais para nós dois",
]

func _ready() -> void:
	text = texts[randi() % texts.size()]
