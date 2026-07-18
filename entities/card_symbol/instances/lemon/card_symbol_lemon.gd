class_name CardSymbolLemon extends CardSymbol


@onready var lemon_animator: AnimationPlayer = $LemonAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0.25, cue))
	add_hit(HitData.new(0.25, 0, hit))


func cue() -> void:
	lemon_animator.stop(true)
	lemon_animator.play("cue")
	cue_sfx.play()


func hit() -> void:
	lemon_animator.stop(true)
	lemon_animator.play("hit")
	hit_sfx.play()
