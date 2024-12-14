extends Node
class_name AttackComponent

enum Strategy {first, last, strongest, weakest, nearest}

var stats: CharacterStats
var can_attack: bool = true
var targets: Array[Character] = []


func _process(_delta):
	if can_attack and len(targets) > 0:
		attack()
		can_attack = false
		await get_tree().create_timer(stats.cooldown).timeout
		can_attack = true

func get_target():
	if stats.strategy == Strategy.first:
		return targets[0]
	elif stats.strategy == Strategy.last:
		return targets[-1]
	elif stats.strategy == Strategy.strongest:
		var strongest = targets[0]
		for target in targets:
			if target.stats.health > strongest.stats.health:
				strongest = target
		return strongest
	elif stats.strategy == Strategy.weakest:
		var weakest = targets[0]
		for target in targets:
			if target.stats.health < weakest.stats.health:
				weakest = target
		return weakest
	elif stats.strategy == Strategy.nearest:
		var nearest = targets[0]
		for target in targets:
			if target.global_position.distance_to(get_parent().global_position) < nearest.global_position.distance_to(get_parent().global_position):
				nearest = target
		return nearest

func attack():
	if len(targets) == 0:
		return
	var current_target = get_target()
	if current_target.is_inside_tree():
		if get_parent().get_node("AttackRangeComponent"):
			var projectile_scene = preload("res://scenes/projectile.tscn")
			var projectile = projectile_scene.instantiate()
			projectile.position = get_parent().global_position
			projectile.target = current_target
			projectile.damage = stats.damage
			get_tree().current_scene.add_child(projectile)
		if not get_parent().get_node("AttackRangeComponent"):
			current_target.get_node("HealthComponent").take_damage(stats.damage)
