class_name CardSymbolHorseshoe extends CardSymbol


@onready var horseshoe_animator: AnimationPlayer = $HorseshoeAnimator


func next_cue() -> void:
	horseshoe_animator.stop(true)
	horseshoe_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	horseshoe_animator.stop(true)
	horseshoe_animator.play("hit")
	hit_player.play()
	super()
