class_name HitData extends Resource


@export var beat: float = 0
@export var hold_time: float = 0


func _init(_beat: float, _hold_time: float) -> void:
	beat = _beat
	hold_time = _hold_time
