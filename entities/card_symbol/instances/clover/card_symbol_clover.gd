class_name CardSymbolClover extends CardSymbol


@onready var clover_animator: AnimationPlayer = $CloverAnimator


func next_cue() -> void:
	clover_animator.stop(true)
	clover_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	clover_animator.stop(true)
	clover_animator.play("hit")
	hit_player.play()
	super()
