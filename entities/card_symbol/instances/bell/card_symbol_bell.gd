class_name CardSymbolBell extends CardSymbol


@onready var bell_animator: AnimationPlayer = $BellAnimator


func next_cue() -> void:
	bell_animator.stop(true)
	bell_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	bell_animator.stop(true)
	bell_animator.play("hit")
	hit_player.play()
	super()
