class_name CardSymbolApple extends CardSymbol


@onready var apple_animator: AnimationPlayer = $AppleAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0, cue))
	add_hit(HitData.new(0, 0, hit))


func cue() -> void:
	apple_animator.stop(true)
	apple_animator.play("cue")
	cue_sfx.play()


func hit() -> void:
	apple_animator.stop(true)
	apple_animator.play("hit")
	hit_sfx.play()
