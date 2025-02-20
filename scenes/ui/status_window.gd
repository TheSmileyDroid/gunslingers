extends PanelContainer

var current_character: Character
var is_right_side := true

func _ready() -> void:
	Events.character_selected.connect(_on_character_selected)
	Events.character_deselected.connect(_on_character_deselected)
	visible = false
	%TogglePosition.pressed.connect(_on_toggle_position_pressed)

func _on_toggle_position_pressed() -> void:
	is_right_side = !is_right_side

	# Configura a posição alvo
	var viewport_size = get_viewport_rect().size
	var target_x = viewport_size.x - size.x if is_right_side else 0

	# Cria e configura o tween
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	# Anima a posição
	tween.tween_property(self, "position:x", target_x, 0.3)


func _on_character_selected(character: Character) -> void:
	current_character = character
	%Name.text = character.stats.name
	%Stats.text = character.stats.to_display_string()

	# Limpa lista de upgrades
	for child in %UpgradeList.get_children():
		child.queue_free()

	# Adiciona botões de upgrade
	for upgrade in character.stats.upgrades:
		var button = preload("res://scenes/ui/upgrade_button.tscn").instantiate()
		button.setup(upgrade, character)
		button.upgrade_purchased.connect(_on_upgrade_purchased)
		%UpgradeList.add_child(button)

	visible = true

	# Define a posição inicial quando abrir
	var viewport_size = get_viewport_rect().size
	position.x = viewport_size.x - size.x if is_right_side else 0

func _on_character_deselected() -> void:
	current_character = null
	visible = false

func _on_upgrade_purchased(upgrade: CharacterUpgrade) -> void:
	if current_character == null:
		return

	if get_tree().current_scene.cash >= upgrade.cost:
		current_character.stats.apply_upgrade(upgrade)
		get_tree().current_scene.cash -= upgrade.cost
		Events.cash_changed.emit(get_tree().current_scene.cash)
		_on_character_selected(current_character) # Atualiza a janela
