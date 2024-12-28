extends Node
class_name AttackComponent

enum Strategy {first, last, strongest, weakest, nearest}

var character: Character

signal attack_started(character: Character)

var starting_attack: bool = false

func _ready():
	character = get_parent()

func _process(_delta):
	if len(character.get_node("DetectionArea").targets) > 0:
		attack()
		

func get_target():
	if len(character.get_node("DetectionArea").targets) == 0:
		return null
	if character.stats.strategy == Strategy.first:
		return character.get_node("DetectionArea").targets[0]
	elif character.stats.strategy == Strategy.last:
		return character.get_node("DetectionArea").targets[-1]
	elif character.stats.strategy == Strategy.strongest:
		var strongest = character.get_node("DetectionArea").targets[0]
		for target in character.get_node("DetectionArea").targets:
			if target.character.stats.health > strongest.character.stats.health:
				strongest = target
		return strongest
	elif character.stats.strategy == Strategy.weakest:
		var weakest = character.get_node("DetectionArea").targets[0]
		for target in character.get_node("DetectionArea").targets:
			if target.character.stats.health < weakest.character.stats.health:
				weakest = target
		return weakest
	elif character.stats.strategy == Strategy.nearest:
		var nearest = character.get_node("DetectionArea").targets[0]
		for target in character.get_node("DetectionArea").targets:
			if target.global_position.distance_to(get_parent().global_position) < nearest.global_position.distance_to(get_parent().global_position):
				nearest = target
		return nearest

func attack():
	if len(character.get_node("DetectionArea").targets) == 0 or starting_attack:
		return
	var current_target = get_target()
	if is_instance_valid(current_target) and character.get_node("FireRateComponent").is_stopped():
		attack_started.emit(character)
		character.get_node("FireRateComponent").start()

func finish_attack():
	
	var current_target = get_target()
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
		if character.stats.attack_type == CharacterData.AttackType.melee:
			current_target.get_node("HealthComponent").take_damage(character.stats.damage, character)
		starting_attack = false