class_name CardSymbolCherry extends CardSymbol


@onready var cherry_animator: AnimationPlayer = $CherryAnimator


func next_cue() -> void:
	cherry_animator.stop(true)
	cherry_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	cherry_animator.stop(true)
	cherry_animator.play("hit")
	hit_player.play()
	super()
