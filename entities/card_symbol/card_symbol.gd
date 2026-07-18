class_name CardSymbol extends Node2D


signal symbol_spawned(this: CardSymbol)
signal symbol_hit(this: CardSymbol, rating: Utils.HitRating)


@onready var sprite: Sprite2D = $Sprite
@onready var hit_sfx: AudioStreamPlayer = %HitSfx
@onready var cue_sfx: AudioStreamPlayer = %CueSfx
@onready var main_animator: AnimationPlayer = %MainAnimator


var hits: Array[HitData]
var cues: Array[CueData]

var level_context: LevelContext
var slot_id: int
var cue_base: int
var hit_base: int

var is_missed: bool = false


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing or is_missed:
		return
	
	process_cues()

	if not hits.is_empty():
		process_hits()


func process_cues() -> void:
	var unused_cues = cues.filter(func(cue: CueData): return not cue.used)
	for cue: CueData in unused_cues:
		var cue_time := (cue_base + cue.beat) * RhythmPlayer.beat_length
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
	var hit_time := (hit_base + hit.beat) * RhythmPlayer.beat_length
	var hit_delta := (RhythmPlayer.song_position - hit_time) * 1000

	if hit_delta > level_context.windows.ok or Input.is_action_just_pressed("hit"):
		var rating := level_context.get_rating(hit_delta)
		symbol_hit.emit(self, rating)

		if rating == Utils.HitRating.IGNORED:
			return

		hits.pop_back()
		if rating == Utils.HitRating.MISS:
			is_missed = true
		else:
			hit.effect.call()


func process_hold(_hold: HitData) -> void:
	pass


func setup(_slot_id: int, _cue_base: int, _hit_base: int, _level_context: LevelContext) -> void:
	slot_id = _slot_id
	cue_base = _cue_base
	hit_base = _hit_base
	level_context = _level_context


func spawn() -> void:
	main_animator.play("spawn")
	symbol_spawned.emit(self)
	on_spawn()


func despawn() -> void:
	main_animator.play("despawn")


func add_hit(hit: HitData) -> void:
	hits.push_back(hit)
	sort_hits()


func sort_hits() -> void:
	hits.sort_custom(func(hit_x: HitData, hit_y: HitData): return hit_x.beat > hit_y.beat)


func remove_hit_at(idx: int) -> void:
	hits.remove_at(idx)


func add_cue(cue: CueData) -> void:
	cues.push_back(cue)
	
	
func next_frame() -> void:
	sprite.frame += 1


func on_spawn() -> void:
	pass
