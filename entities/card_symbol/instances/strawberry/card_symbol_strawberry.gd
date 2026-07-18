class_name CardSymbolStrawberry extends CardSymbol


@onready var strawberry_animator: AnimationPlayer = $StrawberryAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0.5, cue))
	add_hit(HitData.new(0.5, 0, hit))


func cue() -> void:
	strawberry_animator.stop(true)
	strawberry_animator.play("cue")
	cue_sfx.play()


func hit() -> void:
	strawberry_animator.stop(true)
	strawberry_animator.play("hit")
	hit_sfx.play()
