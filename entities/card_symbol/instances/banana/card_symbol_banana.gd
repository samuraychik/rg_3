class_name CardSymbolBanana extends CardSymbol


@onready var banana_animator: AnimationPlayer = $BananaAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0.0, cue))
	add_hit(HitData.new(0.0, 0, hit))

	add_cue(CueData.new(0.333, cue))
	add_hit(HitData.new(0.333, 0, hit))

	add_cue(CueData.new(0.667, cue))
	add_hit(HitData.new(0.667, 0, hit))


func cue() -> void:
	banana_animator.stop(true)
	banana_animator.play("cue")
	cue_sfx.play()


func hit() -> void:
	banana_animator.stop(true)
	banana_animator.play("hit")
	hit_sfx.play()
