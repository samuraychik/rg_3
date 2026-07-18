class_name CardSymbolSeven extends CardSymbol


const AMEN_BREAK_HITS = [0.0, 0.5, 1.0, 1.5, 1.75, 2.25, 2.5]


@onready var seven_animator: AnimationPlayer = $SevenAnimator


func on_spawn() -> void:
	level_context.full_pattern.connect(on_full_pattern)
	add_cue(CueData.new(0.0, cue))
	add_hit(HitData.new(0.0, 0.0, hit))


func cue() -> void:
	cue_sfx.play()
	seven_animator.stop(true)
	seven_animator.play("cue")


func hit() -> void:
	hit_sfx.play()
	seven_animator.stop(true)
	seven_animator.play("hit")


func hit_amen() -> void:
	hit_sfx.play()
	seven_animator.stop(true)
	seven_animator.play("hit_amen")


func on_full_pattern() -> void:
	if level_context.slots.size() != 3:
		return
	
	if level_context.slots.all(func(card: CardData): return card != null and card.symbol == Utils.CardSymbol.SEVEN):
		remove_hit_at(0)
		for beat: float in AMEN_BREAK_HITS:
			level_context.jackpot.emit()
			add_hit(HitData.new(beat - slot_id, 0.0, hit_amen))
