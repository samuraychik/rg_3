class_name LevelScene extends Node2D


@onready var lever: Lever = $Lever

@onready var slots_holder: Node2D = $SlotsHolder
@onready var combo_label: JumpyLabel = $ComboLabel
@onready var rating_label: JumpyLabel = $RatingLabel

@onready var miss_sfx: AudioStreamPlayer = $MissSfx
@onready var level_animator: AnimationPlayer = $LevelAnimator

@export var card_scene: PackedScene
@export var slot_scene: PackedScene


var slots: Array[Slot]

var level_context: LevelContext
var current_beat: int
var is_cue_phase: bool

var combo: int = 0:
	set(value):
		combo = value
		combo_label.set_label(str(combo))


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing:
		return
	
	if RhythmPlayer.song_position >= current_beat * RhythmPlayer.beat_length:
		on_beat()
		current_beat += 1
		print(current_beat)
		if current_beat > level_context.length:
			RunManager.finish_level()

	if Input.is_action_just_pressed("hit"):
		verify_hit(RhythmPlayer.song_position)


func on_beat() -> void:
	var beat_id = current_beat % level_context.bar_size
	if beat_id == 0:
		is_cue_phase = not is_cue_phase
		
	if is_cue_phase:
		if beat_id == level_context.bar_size - 1:
			level_context.full_pattern.emit()
			return
	
		draw_card(beat_id)


func setup(deck: DeckData, level: LevelData) -> void:
	level_context = LevelContext.new()
	level_context.deck = deck.cards.duplicate_deep()
	level_context.length = level.length
	level_context.windows = level.windows
	level_context.bar_size = level.bar_size
	level_context.slots = []

	RhythmPlayer.set_song(level.song_file, level.bpm, level.offset, level.db_modifier)
	current_beat = 0
	is_cue_phase = false

	setup_slots()
	lever.setup(level_context)
	lever.lever_hit.connect(on_lever_hit)
	

func setup_slots() -> void:
	for i in range(level_context.bar_size - 1):
		var slot: Slot = slot_scene.instantiate()
		slots_holder.add_child(slot)
		slot.position = Vector2i(111 + 49 * i, 88)
		slots.push_back(slot)
		level_context.slots.push_back(null)


func draw_card(slot_id: int) -> void:
	var card_data := level_context.draw()
	var card: Card = card_scene.instantiate()
	slots[slot_id].set_card(card)
	level_context.slots[slot_id] = card_data
	card.setup(card_data, slot_id, current_beat, current_beat + level_context.bar_size, level_context)
	card.symbol_hit.connect(on_symbol_hit)
	card.spawn()
	level_context.card_drawn.emit()


func discard_cards() -> void:
	for slot_id in range(slots.size()):
		level_context.slots[slot_id] = null
		slots[slot_id].discard()


func on_symbol_hit(_symbol: CardSymbol, rating: Utils.HitRating) -> void:
	if rating == Utils.HitRating.IGNORED:
		return

	process_rating(rating)


func on_lever_hit(rating: Utils.HitRating) -> void:
	if rating == Utils.HitRating.IGNORED:
		return

	process_rating(rating)
	discard_cards()


func process_rating(rating: Utils.HitRating) -> void:
	rating_label.self_modulate = get_rating_color(rating)
	rating_label.set_label(Utils.get_rating_string(rating))
	if rating == Utils.HitRating.MISS:
		combo = 0
	else:
		combo += 1


func get_rating_color(rating: Utils.HitRating) -> Color:
	match rating:
		Utils.HitRating.PERFECT:
			return Color.from_rgba8(255, 213, 65)
		Utils.HitRating.GREAT:
			return Color.from_rgba8(244, 210, 156)
		Utils.HitRating.GOOD:
			return Color.from_rgba8(219, 164, 99)
		Utils.HitRating.OK:
			return Color.from_rgba8(187, 117, 71)
		Utils.HitRating.MISS:
			return Color.from_rgba8(180, 32, 42)
		_:
			return Color.WHITE


func verify_hit(hit_time: float) -> void:
	const BAD_RATINGS = [Utils.HitRating.MISS, Utils.HitRating.IGNORED]

	var next_hits: Array[float] = []

	for slot in slots:
		if slot.card == null:
			next_hits.push_back(-INF)
			continue
		next_hits.push_back(slot.card.symbol_node.get_next_hit_time())
	next_hits.push_back(lever.next_hit_time)

	if next_hits.all(func(x: float): return BAD_RATINGS.has(level_context.get_rating(hit_time - x))):
		on_false_hit()
		return

	var active_hits := next_hits.filter(func(x: float): return not BAD_RATINGS.has(level_context.get_rating(hit_time - x)))
	if not active_hits.is_empty():
		level_context.hit_verified.emit(active_hits.min())
	

func on_false_hit() -> void:
	process_rating(Utils.HitRating.MISS)
	level_animator.stop()
	level_animator.play("miss")
	miss_sfx.play()
	