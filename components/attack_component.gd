extends Node
class_name AttackComponent

enum Strategy {first, last, strongest, weakest, nearest}

var character: Character

signal attack_started(character: Character)

func _ready():
	character = get_parent()


func get_target():
	var valid_targets = []
	for target in character.get_node("DetectionArea").targets:
		# Se for um curador, só pega alvos da mesma equipe que precisam de cura
		if character.stats.attack_type == CharacterData.AttackType.heal:
			if target.team == character.team and target.stats.health < target.stats.max_health:
				valid_targets.append(target)
		# Se for atacante, só pega alvos da equipe oposta
		else:
			if target.team != character.team:
				valid_targets.append(target)

	if valid_targets.is_empty():
		return null

	if character.stats.strategy == Strategy.first:
		var first = valid_targets[0]
		for target in valid_targets:
			if target.time_alive > first.time_alive:
				first = target
		return first
	elif character.stats.strategy == Strategy.last:
		var last = valid_targets[-1]
		for target in valid_targets:
			if target.time_alive < last.time_alive:
				last = target
		return last
	elif character.stats.strategy == Strategy.strongest:
		var strongest = valid_targets[0]
		for target in valid_targets:
			if target.stats.health > strongest.stats.health:
				strongest = target
		return strongest
	elif character.stats.strategy == Strategy.weakest:
		var weakest = valid_targets[0]
		for target in valid_targets:
			if target.stats.health < weakest.stats.health:
				weakest = target
		return weakest
	elif character.stats.strategy == Strategy.nearest:
		var nearest = valid_targets[0]
		for target in valid_targets:
			if target.global_position.distance_to(get_parent().global_position) < nearest.global_position.distance_to(get_parent().global_position):
				nearest = target
		return nearest

func attack():
	if len(character.get_node("DetectionArea").targets) == 0:
		return
	var current_target = get_target()
	if is_instance_valid(current_target):
		attack_started.emit(character)
		character.get_node("FireRateComponent").start()
		finish_attack(current_target)


func finish_attack(current_target: Character):
	if is_instance_valid(current_target):
		if character.stats.attack_type == CharacterData.AttackType.ranged:
			var projectile_scene = preload("res://scenes/projectile.tscn")
			var projectile = projectile_scene.instantiate()
			projectile.position = get_parent().global_position
			projectile.source = character
			projectile.target = current_target
			projectile.damage = character.stats.damage
			projectile.max_hits = character.stats.pierce
			get_tree().current_scene.add_child(projectile)
		elif character.stats.attack_type == CharacterData.AttackType.melee:
			current_target.get_node("HealthComponent").take_damage(character.stats.damage, character)
		elif character.stats.attack_type == CharacterData.AttackType.heal:
			current_target.stats.health = min(current_target.stats.health + character.stats.damage, current_target.stats.max_health)
