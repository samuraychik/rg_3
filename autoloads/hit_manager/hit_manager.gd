extends Node


signal hit(hit: HitData, rating: String)
signal miss(miss: HitData)


@onready var miss_player: AudioStreamPlayer = $MissPlayer
@onready var apple_player: AudioStreamPlayer = $ApplePlayer
@onready var cherry_player: AudioStreamPlayer = $CherryPlayer
@onready var banana_player: AudioStreamPlayer = $BananaPlayer
@onready var clover_player: AudioStreamPlayer = $CloverPlayer
@onready var bell_player: AudioStreamPlayer = $BellPlayer
@onready var cowbell_player: AudioStreamPlayer = $CowbellPlayer
@onready var strawberry_player: AudioStreamPlayer = $StrawberryPlayer
@onready var lemon_player: AudioStreamPlayer = $LemonPlayer
@onready var lever_player: AudioStreamPlayer = $LeverPlayer


var windows: Dictionary[Utils.HitRating, float]
var hits: Array[HitData]
var next_hit: HitData


func set_hits(new_hits: Array[HitData]) -> void:
	new_hits.sort_custom(_sort_hits)
	hits = new_hits
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
	next_hit = hits.pop_back()


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing or not next_hit:
		return
	
	var hit_delta = (RhythmPlayer.current_beat - next_hit.beat) * RhythmPlayer.beat_length * 1000
	if hit_delta > windows[Utils.HitRating.OK]:
		print("MISSED: ", hit_delta, "ms")
		play_miss()
		set_next_hit()

	if Input.is_action_just_pressed("hit"):
		if hit_delta < -windows[Utils.HitRating.OK]:
			print("TOO EARLY: ", hit_delta, "ms")
			play_miss()
		else:
			var rating: String = get_rating_string(hit_delta)
			print(rating, ": ", hit_delta, "ms")
			play_hit(rating)
			set_next_hit()


func get_rating_string(hit_delta: float) -> String:
	if abs(hit_delta) < windows[Utils.HitRating.PERFECT]:
		return "PERFECT"
	elif abs(hit_delta) < windows[Utils.HitRating.GREAT]:
		return "GREAT"
	elif abs(hit_delta) < windows[Utils.HitRating.GOOD]:
		return "GOOD"
	return "OK"


func get_sfx_player(symbol: Utils.CardSymbol) -> AudioStreamPlayer:
	match symbol:
		Utils.CardSymbol.APPLE:
			return apple_player
		Utils.CardSymbol.CHERRY:
			return cherry_player
		Utils.CardSymbol.BANANA:
			return banana_player
		Utils.CardSymbol.CLOVER:
			return clover_player
		Utils.CardSymbol.BELL:
			return bell_player
		Utils.CardSymbol.COWBELL:
			return cowbell_player
		Utils.CardSymbol.STRAWBERRY:
			return strawberry_player
		Utils.CardSymbol.LEMON:
			return lemon_player
		Utils.CardSymbol.LEVER:
			return lever_player
		_:
			return apple_player


func play_hit(rating: String) -> void:
	hit.emit(next_hit, rating)
	get_sfx_player(next_hit.symbol).play()


func play_miss() -> void:
	miss.emit(next_hit)
	miss_player.play()
