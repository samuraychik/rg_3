class_name CardSymbolGrape extends CardSymbol


@onready var grape_animator: AnimationPlayer = $GrapeAnimator
@onready var grape_shoot_animator: AnimationPlayer = $GrapeShootAnimator


func next_cue() -> void:
	grape_animator.stop(true)
	grape_animator.play("cue_%s" % cue_state)
	cue_player.play()
	super()


func next_hit() -> void:
	if hit_state == 0:
		grape_animator.stop(true)
		grape_animator.play("hit")
	elif hit_state == 1:
		grape_shoot_animator.stop(true)
		grape_shoot_animator.play("hit")
	hit_player.play()
	super()
