class_name CardSymbolTheo extends CardSymbol


@onready var theo_animator: AnimationPlayer = $TheoAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0, cue))
	add_hit(HitData.new(0, 0, hit))


func cue() -> void:
	theo_animator.stop(true)
	theo_animator.play("cue")
	cue_sfx.play()


func hit() -> void:
	theo_animator.stop(true)
	theo_animator.play("hit")
	hit_sfx.play()
