class_name CueData extends Resource


@export var beat: float
@export var symbol: Utils.CardSymbol


func _init(_beat: float, _symbol: Utils.CardSymbol) -> void:
	beat = _beat
	symbol = _symbol
