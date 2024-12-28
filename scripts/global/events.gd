extends Node

@warning_ignore("unused_signal")
signal player_died
@warning_ignore("unused_signal")
signal player_won

@warning_ignore("unused_signal")
signal changed_level(level_name: String)

@warning_ignore("unused_signal")
signal character_mouse_enter(character: Character)
@warning_ignore("unused_signal")
signal character_mouse_exit(character: Character)

@warning_ignore("unused_signal")
signal save_game(save_name: String)
@warning_ignore("unused_signal")
signal load_game(save_name: String)

@warning_ignore("unused_signal")
signal character_drag(tower_id: String)

@warning_ignore("unused_signal")
signal received_reward(amount: int)

@warning_ignore("unused_signal")
signal buy_character(character_id: String)

@warning_ignore("unused_signal")
signal cash_changed(amount: int)