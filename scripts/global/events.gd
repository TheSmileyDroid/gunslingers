extends Node

signal player_died
signal player_won

signal changed_level(level_name: String)

signal character_mouse_enter(character: Character)
signal character_mouse_exit(character: Character)

signal save_game(save_name: String)
signal load_game(save_name: String)