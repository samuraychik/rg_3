extends Node


signal cue(cue: CueData)

@onready var lever_player: AudioStreamPlayer = $LeverPlayer

var cues: Array[CueData]
var next_cue: CueData


func set_cues(new_cues: Array[CueData]) -> void:
	new_cues.sort_custom(_sort_cues)
	cues = new_cues
	set_next_cue()


func _sort_cues(cue_a: CueData, cue_b: CueData) -> bool:
	return cue_a.beat > cue_b.beat


func set_next_cue() -> void:
	next_cue = cues.pop_back()


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing or not next_cue:
		return
	
	if RhythmPlayer.current_beat >= next_cue.beat:
		cue.emit(next_cue)
		if next_cue.symbol == Utils.CardSymbol.LEVER:
			lever_player.play()
		set_next_cue()
