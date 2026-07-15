class_name CardSymbol extends Node2D


signal symbol_spawned(this: CardSymbol)
signal symbol_hit(this: CardSymbol, rating: Utils.HitRating)


@export var hits: Array[HitData]
@export var cues: Array[CueData]


@onready var sprite: Sprite2D = $Sprite
@onready var hit_player: AudioStreamPlayer = %HitPlayer
@onready var cue_player: AudioStreamPlayer = %CuePlayer
@onready var main_animator: AnimationPlayer = %MainAnimator


var level_context: LevelContext
var cue_phase_time: float
var hit_phase_time: float


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing:
		return
	
	process_cues()

	if not hits.is_empty():
		process_hits()


func process_cues() -> void:
	var unused_cues = cues.filter(func(cue: CueData): return not cue.used)
	for cue: CueData in unused_cues:
		var cue_time := (cue_phase_time + cue.beat) * RhythmPlayer.beat_length
		if RhythmPlayer.song_position >= cue_time:
			cue.effect.call()
			cue.used = true


func process_hits() -> void:
	var hit: HitData = hits.back()
	if hit.hold_time == 0:
		process_hit(hit)
	else:
		process_hold(hit)


func process_hit(hit: HitData) -> void:
	var hit_time := (hit_phase_time + hit.beat) * RhythmPlayer.beat_length
	var hit_delta := RhythmPlayer.song_position - hit_time

	if hit_delta > level_context.windows.ok or Input.is_action_just_pressed("hit"):
		var rating := get_rating(hit_delta)
		symbol_hit.emit(self, rating)
		print(rating)


func process_hold(_hold: HitData) -> void:
	pass


func get_rating(delta: float) -> Utils.HitRating:
	if delta > level_context.windows.ok:
		return Utils.HitRating.MISS
	
	if delta < -level_context.windows.ok:
		return Utils.HitRating.IGNORED
	
	var abs_delta = absf(delta)
	if abs_delta <= level_context.windows.perfect:
		return Utils.HitRating.PERFECT
	elif abs_delta <= level_context.windows.great:
		return Utils.HitRating.GREAT
	elif abs_delta <= level_context.windows.good:
		return Utils.HitRating.GOOD
	else:
		return Utils.HitRating.OK


func setup(_cue_time: float, _play_time: float, _level_context: LevelContext) -> void:
	cue_phase_time = _cue_time
	hit_phase_time = _play_time
	level_context = _level_context


func spawn() -> void:
	main_animator.play("spawn")
	symbol_spawned.emit(self)


func despawn() -> void:
	main_animator.play("despawn")


func add_hit(hit: HitData) -> void:
	hits.push_back(hit)
	sort_hits()


func sort_hits() -> void:
	hits.sort_custom(func(hit_x: HitData, hit_y: HitData): return hit_x.beat > hit_y.beat)


func add_cue(cue: HitData) -> void:
	cues.push_back(cue)
	
	
func next_frame() -> void:
	sprite.frame += 1