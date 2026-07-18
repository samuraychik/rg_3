class_name LevelScene extends Node2D


@onready var slots_holder: Node2D = $SlotsHolder
@onready var combo_label: Label = $ComboLabel
@onready var rating_label: Label = $RatingLabel
@onready var score_label: Label = $ScoreLabel


@export var card_scene: PackedScene
@export var slot_scene: PackedScene


var slots: Array[Slot]

var level_context: LevelContext
var bar_size: int
var current_beat: int
var is_cue_phase: bool

var score: int = 0:
	set(value):
		score = value
		score_label.text = str(score)
var combo: int = 0:
	set(value):
		combo = value
		combo_label.text = str(combo)


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing:
		return
	
	if RhythmPlayer.song_position >= current_beat * RhythmPlayer.beat_length:
		on_beat()
		current_beat += 1


func on_beat() -> void:
	var beat_id = current_beat % bar_size
	if beat_id == 0:
		is_cue_phase = not is_cue_phase
		
	if is_cue_phase:
		if beat_id == bar_size - 1:
			level_context.full_pattern.emit()
			return

		if beat_id == 0:
			discard_cards()
	
		draw_card(beat_id)


func setup(deck: DeckData, level: LevelData) -> void:
	level_context = LevelContext.new()
	level_context.deck = deck.cards.duplicate_deep()
	level_context.windows = level.windows
	level_context.slots = []

	bar_size = level.bar_size
	current_beat = 0
	is_cue_phase = false
	
	setup_slots()
	RhythmPlayer.set_song(level.song_file, level.bpm, level.offset, level.db_modifier)


func setup_slots() -> void:
	for i in range(bar_size - 1):
		var slot: Slot = slot_scene.instantiate()
		slots_holder.add_child(slot)
		slot.position = Vector2i(112 + 48 * i, 88)
		slots.push_back(slot)
		level_context.slots.push_back(null)


func draw_card(slot_id: int) -> void:
	var card_data := level_context.draw()
	var card: Card = card_scene.instantiate()
	slots[slot_id].set_card(card)
	level_context.slots[slot_id] = card_data
	card.setup(card_data, slot_id, current_beat, current_beat + bar_size, level_context)
	card.symbol_hit.connect(on_symbol_hit)
	card.spawn()
	level_context.card_drawn.emit()


func discard_cards() -> void:
	for slot_id in range(slots.size()):
		level_context.slots[slot_id] = null
		slots[slot_id].discard()


func on_symbol_hit(symbol: CardSymbol, rating: Utils.HitRating) -> void:
	if rating == Utils.HitRating.IGNORED:
		print("ignored!")


# TO-DO: make lever a real entity
