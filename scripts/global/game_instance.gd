extends Node

var save_data: SaveData

func _ready():
    save_data = load_game()
    if not save_data:
        save_data = SaveData.new()
        save_data.name = "Player"
        save_data.current_level = "test"
        save_data.money = 0
        save_data.time_played = 0.0
        save_game()

    Events.save_game.connect(save_game)
    Events.load_game.connect(load_game)

func save_game(save_name: String = "savegame") -> void:
    var error := ResourceSaver.save(save_data, "user://%s.res" % save_name)
    if error != OK:
        print("Error saving game: ", error)
    else:
        print("Game saved")

func load_game(save_name: String = "savegame") -> SaveData:
    var save = load("user://%s.res" % save_name)
    if save:
        save_data = save
        print("Game loaded")
        return save_data
    else:
        print("No save file found")
        return null
