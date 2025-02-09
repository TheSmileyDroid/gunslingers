extends Resource
class_name MapData

@export var name: String = "Map"
@export var difficulty: int = 5
@export var initial_cash: int = 100
@export var initial_lives: int = 10
@export var waves: Array[WaveData] = []
@export var initial_dialog: DialogData
@export var victory_dialog: DialogData
@export var passive_income: int = 10
