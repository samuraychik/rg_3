class_name LevelScene extends Node2D


const CARD = preload("uid://bdvybsrf48rg7")


@export var level: LevelData
@export var deck: DeckData


@onready var slots: Array[Slot] = [%Slot0, %Slot1, %Slot2]
@onready var combo_label: Label = $ComboLabel
@onready var rating_label: Label = $RatingLabel
@onready var score_label: Label = $ScoreLabel


var cards: Array[CardData]
var score: int = 0:
	set(value):
		score = value
		score_label.text = str(score)
var combo: int = 0:
	set(value):
		combo = value
		combo_label.text = str(combo)


func setup(new_deck: DeckData, new_level: LevelData) -> void:
	level = new_level
	deck = new_deck
	
	RhythmPlayer.set_song(level.song_file, level.bpm, level.offset, level.db_modifier)
	HitManager.set_windows(level.windows)
	setup_cards()
	setup_signals()


func setup_signals() -> void:
	HitManager.no_hits.connect(on_no_hits)
	HitManager.hit.connect(on_hit)
	HitManager.miss.connect(on_miss)


func setup_cards() -> void:
	var cues: Array[CueData] = []
	var hits: Array[HitData] = []

	var bar_size = level.bar_size
	var pattern_size = bar_size - 1
	var patterns_count = ceil(float(level.length) / bar_size)

	for pattern_idx in range(patterns_count):
		var lever_cue_time = pattern_idx * (bar_size * 2) + pattern_size
		var lever_hit_time = lever_cue_time + bar_size
		cues.push_back(CueData.new(lever_cue_time, Utils.CardSymbol.LEVER))
		hits.push_back(HitData.new(lever_hit_time, Utils.CardSymbol.LEVER))
		
		var pattern_cards: Array[CardData] = []
		for p in range(pattern_size):
			pattern_cards.push_back(get_next_card())

		# Amen Break Jackpot for Kerus
		if len(pattern_cards) == 3 and pattern_cards.all(func(card: CardData): return card != null and card.symbol == Utils.CardSymbol.SEVEN):
			var spawn_time = pattern_idx * (bar_size * 2)
			var despawn_time = (pattern_idx + 1) * (bar_size * 2)
			for cue in range(3):
				cues.push_back(CueData.new(spawn_time + cue, Utils.CardSymbol.SEVEN))
			var hit_time = spawn_time + bar_size
			var amen_hits = [0.0, 0.5, 1.0, 1.5, 1.75, 2.25, 2.5]
			for hit in amen_hits:
				hits.push_back(HitData.new(hit_time + hit, Utils.CardSymbol.SEVEN))

			var card_0: Card = CARD.instantiate()
			slots[0].add_card(card_0)
			card_0.setup(pattern_cards[0], spawn_time, despawn_time, [spawn_time], [hit_time, hit_time + 0.5], true)
			var card_1: Card = CARD.instantiate()
			slots[1].add_card(card_1)
			card_1.setup(pattern_cards[1], spawn_time + 1, despawn_time, [spawn_time + 1], [hit_time + 1, hit_time + 1.5, hit_time + 1.75], true)
			var card_2: Card = CARD.instantiate()
			slots[2].add_card(card_2)
			card_2.setup(pattern_cards[2], spawn_time + 2, despawn_time, [spawn_time + 2], [hit_time + 2.25, hit_time + 2.5], true)

			continue

		# this code sucks so much but it's a pain to optimize
		# right now when i dont even got the game baseline finito
		for pattern_beat in range(pattern_size):
			var card_data = pattern_cards.pop_back()
			if card_data:
				var card_cues: Array[float]
				var card_hits: Array[float]
				var spawn_time = pattern_idx * (bar_size * 2) + pattern_beat
				var despawn_time = (pattern_idx + 1) * (bar_size * 2)
				for cue in card_data.cues:
					var cue_time = spawn_time + cue
					card_cues.push_back(cue_time)
					cues.push_back(CueData.new(cue_time, card_data.symbol))
				for hit in card_data.hits:
					var hit_time = spawn_time + bar_size + hit
					card_hits.push_back(hit_time)
					hits.push_back(HitData.new(hit_time, card_data.symbol))
				var card: Card = CARD.instantiate()
				slots[pattern_beat].add_card(card)
				card.setup(card_data, spawn_time, despawn_time, card_cues, card_hits)

	CueManager.set_cues(cues)
	HitManager.set_hits(hits)
	draw_cards()


func get_next_card() -> CardData:
	if len(cards) <= 0:
		cards = deck.cards.duplicate()
		cards.shuffle()
	return cards.pop_back()


func draw_cards() -> void:
	for slot in slots:
		slot.next()


func on_hit(hit: HitData, rating: String) -> void:
	combo += 1
	
	if hit.symbol == Utils.CardSymbol.LEVER:
		draw_cards()
	
	rating_label.text = "%s!" % rating
	match rating:
		"OK":
			rating_label.modulate = Color(0, 0.7, 1)
			score += 100 * combo
		"GOOD":
			rating_label.modulate = Color(0, 1, 0.4)
			score += 250 * combo
		"GREAT":
			rating_label.modulate = Color(0.7, 1, 0)
			score += 500 * combo
		"PERFECT":
			rating_label.modulate = Color(1, 0.7, 0)
			score += 1000 * combo

func on_miss(hit: HitData, late: bool) -> void:
	combo = 0
	if hit.symbol == Utils.CardSymbol.LEVER and late:
		draw_cards()
	
	rating_label.modulate = Color(0.7, 0, 0)
	if late:
		rating_label.text = "MISS!"
	else:
		rating_label.text = "EARLY!"

func on_no_hits() -> void:
	RunManager.finish_level()
