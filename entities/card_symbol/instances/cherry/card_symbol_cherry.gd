class_name CardSymbolCherry extends CardSymbol


@onready var cherry_animator: AnimationPlayer = $CherryAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0, cue))
	add_hit(HitData.new(0, 0, hit))

	add_cue(CueData.new(0.5, cue))
	add_hit(HitData.new(0.5, 0, hit))


func cue() -> void:
	cherry_animator.stop(true)
	cherry_animator.play("cue")
	cue_sfx.play()


func hit() -> void:
	cherry_animator.stop(true)
	cherry_animator.play("hit")
	hit_sfx.play()
