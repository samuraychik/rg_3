extends Node


signal cue(cue: CueData)


@onready var generic_player: AudioStreamPlayer = $GenericPlayer


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
		play_cue()
		set_next_cue()


func get_sfx_player() -> AudioStreamPlayer:
	return generic_player


func play_cue() -> void:
	cue.emit(next_cue)
	get_sfx_player().play()
