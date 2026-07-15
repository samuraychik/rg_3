class_name CardSymbolCherry extends CardSymbol


@onready var cherry_animator: AnimationPlayer = $CherryAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0, on_cue))
	add_hit(HitData.new(0, 0, on_hit))

	add_cue(CueData.new(0.5, on_cue))
	add_hit(HitData.new(0.5, 0, on_hit))


func on_cue() -> void:
	cherry_animator.stop(true)
	cherry_animator.play("cue")
	cue_player.play()


func on_hit() -> void:
	cherry_animator.stop(true)
	cherry_animator.play("hit")
	hit_player.play()
