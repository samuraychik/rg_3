extends Node


signal no_hits
signal hit(hit: HitData, rating: String)
signal miss(miss: HitData, late: bool)


@onready var miss_player: AudioStreamPlayer = $MissPlayer
@onready var lever_player: AudioStreamPlayer = $LeverPlayer


@export var auto_mode: bool = false


var windows: Dictionary[Utils.HitRating, float]
var hits: Dictionary[float, HitArray]
var hit_beats: Array[float]
var next_hit: float = -1


func set_hits(new_hits: Array[HitData]) -> void:
	new_hits.sort_custom(_sort_hits)
	for hit_data in new_hits:
		var hit_array: HitArray = hits.get_or_add(hit_data.beat, HitArray.new())
		hit_array.items.push_back(hit_data)
	hit_beats = hits.keys()
	set_next_hit()


func _sort_hits(hit_a: HitData, hit_b: HitData) -> bool:
	return hit_a.beat > hit_b.beat


func set_windows(new_windows: WindowsData) -> void:
	windows = {
		Utils.HitRating.PERFECT: new_windows.perfect,
		Utils.HitRating.GREAT: new_windows.great,
		Utils.HitRating.GOOD: new_windows.good,
		Utils.HitRating.OK: new_windows.ok,
	}


func set_next_hit() -> void:
	if not hit_beats:
		no_hits.emit()
		next_hit = -1
		return
	next_hit = hit_beats.pop_back()


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing or next_hit == -1:
		return
	
	var hit_delta = (RhythmPlayer.current_beat - next_hit) * RhythmPlayer.beat_length * 1000
	if hit_delta > windows[Utils.HitRating.OK]:
		print("MISSED: ", hit_delta, "ms")
		for hit_data in hits[next_hit].items:
			miss.emit(hit_data, true)
		miss_player.play()
		set_next_hit()
		

	if Input.is_action_just_pressed("hit") or (auto_mode and absf(hit_delta) < windows[Utils.HitRating.PERFECT]):
		if hit_delta < -RhythmPlayer.beat_length * 1000:
			return
		
		if hit_delta < -windows[Utils.HitRating.OK]:
			print("TOO EARLY: ", hit_delta, "ms")
			for hit_data in hits[next_hit].items:
				miss.emit(hit_data, false)
			miss_player.play()
		else:
			var rating: String = get_rating_string(hit_delta)
			print(rating, ": ", hit_delta, "ms")
			for hit_data in hits[next_hit].items:
				hit.emit(hit_data, rating)
				if hit_data.symbol == Utils.CardSymbol.LEVER:
					lever_player.play()
			set_next_hit()


func get_rating_string(hit_delta: float) -> String:
	if abs(hit_delta) < windows[Utils.HitRating.PERFECT]:
		return "PERFECT"
	elif abs(hit_delta) < windows[Utils.HitRating.GREAT]:
		return "GREAT"
	elif abs(hit_delta) < windows[Utils.HitRating.GOOD]:
		return "GOOD"
	return "OK"
