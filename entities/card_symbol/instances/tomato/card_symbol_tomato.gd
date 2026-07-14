class_name CardSymbolTomato extends CardSymbol


@onready var tomato_animator: AnimationPlayer = $TomatoAnimator


func next_cue() -> void:
	tomato_animator.stop(true)
	tomato_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	tomato_animator.stop(true)
	tomato_animator.play("hit")
	hit_player.play()
	super()
