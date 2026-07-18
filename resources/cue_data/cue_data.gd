class_name CueData extends Resource


var beat: float
var effect: Callable

var used: bool = false


func _init(_beat: float, _effect: Callable) -> void:
	beat = _beat
	effect = _effect
