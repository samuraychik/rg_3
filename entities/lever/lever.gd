class_name Lever extends Node2D


signal lever_hit(rating: Utils.HitRating)


@onready var cue_sfx: AudioStreamPlayer = $CueSfx
@onready var hit_sfx: AudioStreamPlayer = $HitSfx
@onready var miss_sfx: AudioStreamPlayer = $MissSfx
@onready var animator: AnimationPlayer = $Animator


var level_context: LevelContext

var bar_length: float
var next_cue_time: float
var next_hit_time: float

var is_hit_blocked: bool = false


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing:
		return

	process_cue()
	process_miss()


func process_cue() -> void:
	if RhythmPlayer.song_position >= next_cue_time:
		cue_sfx.play()
		animator.play("cue")
		next_cue_time += 2 * bar_length


func process_miss() -> void:
	var hit_delta := RhythmPlayer.song_position - next_hit_time

	if Utils.ms(hit_delta) > level_context.windows.ok:
		lever_hit.emit(Utils.HitRating.MISS)
		next_hit_time += 2 * bar_length
		miss_sfx.play()
		animator.play("miss")


func process_hit() -> void:
	var hit_delta := RhythmPlayer.song_position - next_hit_time
	
	var rating := level_context.get_rating(hit_delta)
	lever_hit.emit(rating)
	next_hit_time += 2 * bar_length
	hit_sfx.play()
	animator.play("hit")


func setup(_level_context: LevelContext) -> void:
	level_context = _level_context
	bar_length = level_context.bar_size * RhythmPlayer.beat_length
	
	next_cue_time = bar_length - RhythmPlayer.beat_length
	next_hit_time = next_cue_time + bar_length

	level_context.hit_verified.connect(on_hit_verified)


func on_hit_verified(hit_time: float) -> void:
	if hit_time == next_hit_time:
		process_hit()