class_name CardContext extends Resource


var slot_id: int
var cue_base_time: float
var hit_base_time: float


func _init(_slot_id: int, _cue_base_time: float, _hit_base_time: float) -> void:
  slot_id = _slot_id
  cue_base_time = _cue_base_time
  hit_base_time = _hit_base_time