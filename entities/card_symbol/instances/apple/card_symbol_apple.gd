class_name CardSymbolApple extends CardSymbol


@onready var apple_animator: AnimationPlayer = $AppleAnimator


func next_cue() -> void:
	apple_animator.stop(true)
	apple_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	apple_animator.stop(true)
	apple_animator.play("hit")
	hit_player.play()
	super()
