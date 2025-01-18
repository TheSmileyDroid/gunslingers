extends Control

func start_dialog(data: DialogData) -> void:
	%Dialog.start_dialog(data)
	await %Dialog.dialog_finished