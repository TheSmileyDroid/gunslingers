extends GameButton

signal upgrade_purchased(upgrade: CharacterUpgrade)

var upgrade: CharacterUpgrade

func setup(_upgrade: CharacterUpgrade, character: Character) -> void:
	upgrade = _upgrade
	%Name.text = upgrade.name
	%Description.text = upgrade.description
	%Cost.text = str(upgrade.cost) + "$"

	disabled = character.stats.has_upgrade(upgrade)
	if disabled:
		%Name.modulate = Color(0.5, 0.5, 0.5)
		%Description.modulate = Color(0.5, 0.5, 0.5)
		%Cost.text = "Esgotado"
		%Cost.modulate = Color(1, 0, 0)


func _ready() -> void:
	super._ready()

func _on_pressed() -> void:
	upgrade_purchased.emit(upgrade)
	super._on_pressed()
