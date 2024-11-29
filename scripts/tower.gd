extends Character


func _ready():
	add_to_group("gunslingers")
	super()

func _on_area_entered(body):
	if body.is_in_group("rats"):
		attack_component.targets.append(body)

func _on_area_exited(body):
	if body.is_in_group("rats"):
		attack_component.targets.erase(body)
