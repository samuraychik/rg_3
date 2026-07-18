class_name LevelContext extends Resource

signal full_pattern
signal card_drawn
signal jackpot

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
	if delta > windows.ok:
		return Utils.HitRating.MISS

	if delta < -windows.ok:
		return Utils.HitRating.IGNORED

	var abs_delta = absf(delta)
	if abs_delta <= windows.perfect:
		return Utils.HitRating.PERFECT
	if abs_delta <= windows.great:
		return Utils.HitRating.GREAT
	if abs_delta <= windows.good:
		return Utils.HitRating.GOOD
	return Utils.HitRating.OK
