class_name CardSymbolBanana extends CardSymbol


@onready var banana_animator: AnimationPlayer = $BananaAnimator


func next_cue() -> void:
	banana_animator.stop(true)
	banana_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	banana_animator.stop(true)
	banana_animator.play("hit")
	hit_player.play()
	super()
