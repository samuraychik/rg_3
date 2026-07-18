class_name Lever extends Node2D


signal lever_hit(rating: Utils.HitRating)


@onready var cue_sfx: AudioStreamPlayer = $CueSfx
@onready var hit_sfx: AudioStreamPlayer = $HitSfx
@onready var miss_sfx: AudioStreamPlayer = $MissSfx
@onready var animator: AnimationPlayer = $Animator


var level_context: LevelContext

var bar_length: float
var next_cue: float
var next_hit: float


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing:
		return

	process_cue()
	process_hit()


func process_cue() -> void:
	if RhythmPlayer.song_position >= next_cue:
		cue_sfx.play()
		animator.play("cue")
		next_cue += 2 * bar_length


func process_hit() -> void:
	var hit_delta := (RhythmPlayer.song_position - next_hit) * 1000
	
	if hit_delta > level_context.windows.ok or Input.is_action_just_pressed("hit"):
		var rating := level_context.get_rating(hit_delta)
		lever_hit.emit(rating)

		if rating == Utils.HitRating.IGNORED:
			return

		next_hit += 2 * bar_length
		if rating == Utils.HitRating.MISS:
			miss_sfx.play()
			animator.play("miss")
		else:
			hit_sfx.play()
			animator.play("hit")


func setup(_level_context: LevelContext) -> void:
	level_context = _level_context
	bar_length = level_context.bar_size * RhythmPlayer.beat_length
	
	next_cue = bar_length - RhythmPlayer.beat_length
	next_hit = next_cue + bar_length
