class_name CardSymbolTheo extends CardSymbol


@onready var theo_animator: AnimationPlayer = $TheoAnimator


func next_cue() -> void:
	theo_animator.stop(true)
	theo_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	theo_animator.stop(true)
	theo_animator.play("hit")
	hit_player.play()
	super()
