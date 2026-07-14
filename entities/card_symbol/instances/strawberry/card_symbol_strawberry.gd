class_name CardSymbolStrawberry extends CardSymbol


@onready var strawberry_animator: AnimationPlayer = $StrawberryAnimator


func next_cue() -> void:
	strawberry_animator.stop(true)
	strawberry_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	strawberry_animator.stop(true)
	strawberry_animator.play("hit")
	hit_player.play()
	super()
