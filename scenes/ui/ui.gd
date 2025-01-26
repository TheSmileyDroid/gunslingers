extends Control

func _ready() -> void:
	Events.paused_game.connect(show_pause_menu)
	Events.won_game.connect(show_win_screen)

func start_dialog(data: DialogData) -> void:
	%Dialog.start_dialog(data)
	await %Dialog.dialog_finished

func show_pause_menu() -> void:
	%PauseMenu.show()

func show_win_screen() -> void:
	%WinScreen.show()