extends Node


enum HitRating {
	MISS,
	OK,
	GOOD,
	GREAT,
	PERFECT,
	IGNORED,
}


enum CardSymbol {
	APPLE,
	CHERRY,
	BANANA,
	CLOVER,
	BELL,
	COWBELL,
	STRAWBERRY,
	LEMON,
	TOMATO,
	SEVEN,
	GRAPE,
	BOMB,
	THEO,
	HORSESHOE,
	SUIT_SPADES,
	SUIT_CLUBS,
	SUIT_HEARTS,
	SUIT_DIAMONDS,
	LEVER,
}


enum Curse {
	MUTED,
	DIRTY,
	OFFBEAT,
}


func get_rating_string(rating: HitRating) -> String:
	match rating:
		HitRating.MISS:
			return "MISS"
		HitRating.OK:
			return "OK"
		HitRating.GOOD:
			return "GOOD"
		HitRating.GREAT:
			return "GREAT"
		HitRating.PERFECT:
			return "PERFECT"
		_:
			return ""