extends GameButton


func _ready() -> void:
	Events.is_wave_spawnable.connect(_on_wave_spawnable)
	super._ready()

func _on_wave_spawnable(can_spawn: bool) -> void:
	if can_spawn:
		self.disabled = false
	else:
		self.disabled = true

func _on_pressed() -> void:
	Events.next_wave.emit()
	self.disabled = true
	super._on_pressed()
