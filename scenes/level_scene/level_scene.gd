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
		
	if is_cue_phase and beat_id != bar_size - 1:
		if beat_id == 0:
			discard_cards()
	
		draw_card(beat_id)


func setup(deck: DeckData, level: LevelData) -> void:
	level_context = LevelContext.new()
	level_context.deck = deck.cards.duplicate_deep()
	level_context.windows = level.windows

	bar_size = level.bar_size
	current_beat = 0
	is_cue_phase = true
	
	setup_slots()
	RhythmPlayer.set_song(level.song_file, level.bpm, level.offset, level.db_modifier)


func setup_slots() -> void:
	for i in range(bar_size - 1):
		var slot: Slot = slot_scene.instantiate()
		slots_holder.add_child(slot)
		slot.position = Vector2i(112 + 48 * i, 88)


func draw_card(slot_id: int) -> void:
	var cue_base_time = current_beat * RhythmPlayer.beat_length
	var hit_base_time = cue_base_time + bar_size * RhythmPlayer.beat_length

	var card_data := level_context.draw()
	var card: Card = card_scene.instantiate()
	card.setup(card_data, CardContext.new(slot_id, cue_base_time, hit_base_time), level_context)
	card.spawn()

	level_context.slots[slot_id] = card_data
	slots[slot_id].set_card(card)


func discard_cards() -> void:
	for slot_id in range(len(slots)):
		level_context.slots[slot_id] = null
		slots[slot_id].discard()


# TO-DO: bring back Amen Break Jackpot [0.0, 0.5, 1.0, 1.5, 1.75, 2.25, 2.5]
# TO-DO: make lever a real entity