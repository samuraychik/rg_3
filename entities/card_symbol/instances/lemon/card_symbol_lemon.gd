class_name CardSymbolLemon extends CardSymbol


@onready var lemon_animator: AnimationPlayer = $LemonAnimator


func next_cue() -> void:
	lemon_animator.stop(true)
	lemon_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	lemon_animator.stop(true)
	lemon_animator.play("hit")
	hit_player.play()
	super()
