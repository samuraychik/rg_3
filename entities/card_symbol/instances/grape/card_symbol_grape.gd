class_name CardSymbolGrape extends CardSymbol


@onready var grape_animator: AnimationPlayer = $GrapeAnimator
@onready var grape_shoot_animator: AnimationPlayer = $GrapeShootAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0.0, cue))
	add_hit(HitData.new(0.0, 0.0, hit))

	add_cue(CueData.new(1.5, cue_shoot))
	add_hit(HitData.new(1.5, 0.0, hit_shoot))


func cue() -> void:
	grape_animator.stop(true)
	grape_animator.play("cue")
	cue_sfx.play()


func cue_shoot() -> void:
	grape_animator.stop(true)
	grape_animator.play("cue_shoot")
	grape_shoot_animator.stop(true)
	grape_shoot_animator.play("launch")
	cue_sfx.play()


func hit() -> void:
	grape_animator.stop(true)
	grape_animator.play("hit")
	hit_sfx.play()


func hit_shoot() -> void:
	grape_shoot_animator.stop(true)
	grape_shoot_animator.play("hit")
	hit_sfx.play()