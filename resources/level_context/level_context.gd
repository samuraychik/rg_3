class_name LevelContext extends Resource

signal full_pattern
signal card_drawn
signal jackpot
signal hit_verified(hit_time: float)


var length: float
var windows: WindowsData
var bar_size: int

var deck: Array[CardData]
var draw_pile: Array[CardData]
var slots: Array[CardData]


func draw() -> CardData:
	if draw_pile.is_empty():
		draw_pile = deck.duplicate()
		draw_pile.shuffle()
	return draw_pile.pop_back()


func get_rating(delta: float) -> Utils.HitRating:
	var delta_ms = Utils.ms(delta)

	if delta_ms > windows.ok:
		return Utils.HitRating.MISS

	if delta_ms < -windows.ok:
		return Utils.HitRating.IGNORED

	var abs_delta_ms = absf(delta_ms)
	if abs_delta_ms <= windows.perfect:
		return Utils.HitRating.PERFECT
	if abs_delta_ms <= windows.great:
		return Utils.HitRating.GREAT
	if abs_delta_ms <= windows.good:
		return Utils.HitRating.GOOD
	return Utils.HitRating.OK


func get_card_at(slot_id: int) -> CardData:
	return slots[slot_id]
