class_name CardSymbolApple extends CardSymbol


@onready var apple_animator: AnimationPlayer = $AppleAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0, on_cue))
	add_hit(HitData.new(0, 0, on_hit))


func on_cue() -> void:
	apple_animator.stop(true)
	apple_animator.play("cue")
	cue_player.play()


func on_hit() -> void:
	apple_animator.stop(true)
	apple_animator.play("hit")
	hit_player.play()
