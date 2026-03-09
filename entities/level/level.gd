class_name Level extends Node2D


const CARD = preload("uid://bdvybsrf48rg7")


@export var level: LevelData
@export var deck: Array[CardData]


@onready var slots: Array[Slot] = [%Slot0, %Slot1, %Slot2]


var cards: Array[CardData]


func _ready() -> void:
	setup()
	HitManager.hit.connect(on_hit)
	RhythmPlayer.play()


func setup() -> void:
	var cues: Array[CueData] = []
	var hits: Array[HitData] = []

	var pattern_size = 3
	var hit_delay = pattern_size + 1
	var hit_beat = 2 * hit_delay
	var patterns_count = ceil(float(level.length) / pattern_size)

	for pattern_idx in range(patterns_count):
		var lever_cue_time = pattern_idx * hit_beat + pattern_size
		var lever_hit_time = hit_delay + lever_cue_time
		cues.push_back(CueData.new(lever_cue_time, Utils.CardSymbol.LEVER))
		hits.push_back(HitData.new(lever_hit_time, Utils.CardSymbol.LEVER))
		
		var pattern_cards: Array[CardData] = []
		for p in range(pattern_size):
			pattern_cards.push_back(draw_card())

		for pattern_beat in range(pattern_size):
			var card_data = cards.pop_back()
			if card_data:
				var card_cues: Array[float]
				var card_hits: Array[float]
				var spawn_time = pattern_idx * hit_beat + pattern_beat
				for hit in card_data.hits:
					var cue_time = spawn_time + hit
					var hit_time = hit_delay + cue_time
					card_cues.push_back(cue_time)
					card_hits.push_back(hit_time)
					cues.push_back(CueData.new(cue_time, card_data.symbol))
					hits.push_back(HitData.new(hit_time, card_data.symbol))
				var card: Card = CARD.instantiate()
				slots[pattern_beat].set_card(card)
				card.setup(card_data, spawn_time, card_cues, card_hits)

	CueManager.set_cues(cues)
	HitManager.set_hits(hits)
	HitManager.set_windows(level.windows)
	RhythmPlayer.set_song(level.song_file, level.bpm, level.offset, level.db_modifier)


func draw_card() -> CardData:
	if len(cards) <= 0:
		cards = deck.duplicate()
		cards.shuffle()
	return cards.pop_back()


func clear_cards() -> void:
	for slot in slots:
		slot.clear()


func on_hit(hit: HitData, _rating: String) -> void:
	if hit.symbol == Utils.CardSymbol.LEVER:
		clear_cards()
