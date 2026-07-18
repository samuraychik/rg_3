class_name CardSymbolBell extends CardSymbol


@onready var bell_animator: AnimationPlayer = $BellAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0.0, cue))
	add_hit(HitData.new(0.0, 0, hit))

	add_cue(CueData.new(0.25, cue))
	add_hit(HitData.new(0.25, 0, hit))


func cue() -> void:
	bell_animator.stop(true)
	bell_animator.play("cue")
	cue_sfx.play()


func hit() -> void:
	bell_animator.stop(true)
	bell_animator.play("hit")
	hit_sfx.play()
