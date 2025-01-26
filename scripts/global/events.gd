extends Node

@warning_ignore("unused_signal")
signal player_died
@warning_ignore("unused_signal")
signal player_won

@warning_ignore("unused_signal")
signal changed_level(level_name: String)

@warning_ignore("unused_signal")
signal entered_game

@warning_ignore("unused_signal")
signal exited_game

@warning_ignore("unused_signal")
signal paused_game

@warning_ignore("unused_signal")
signal unpaused_game

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

@warning_ignore("unused_signal")
signal character_died(character: Character)

@warning_ignore("unused_signal")
signal wave_started(wave: int)

@warning_ignore("unused_signal")
signal won_game

@warning_ignore("unused_signal")
signal reset_game

@warning_ignore("unused_signal")
signal character_selected(character: Character)
@warning_ignore("unused_signal")
signal character_deselected

@warning_ignore("unused_signal")
signal lives_changed(lives: int)

@warning_ignore("unused_signal")
signal enemy_has_reached_goal(enemy: Character)
