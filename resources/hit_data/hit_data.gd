class_name HitData extends Resource


var beat: float
var hold_time: float
var effect: Callable


func _init(_beat: float, _hold_time: float, _effect: Callable) -> void:
	beat = _beat
	hold_time = _hold_time
	effect = _effect
