class_name CardSymbolSeven extends CardSymbol


@onready var seven_animator: AnimationPlayer = $SevenAnimator


var amen_mode: bool = false


func next_cue() -> void:
	cue_player.play()
	seven_animator.stop(true)
	seven_animator.play("cue")
	super()


func next_hit() -> void:
	hit_player.play()
	if amen_mode:
		seven_animator.stop(true)
		seven_animator.play("hit_amen")
		return
	seven_animator.stop(true)
	seven_animator.play("hit")
	super()


func set_amen_mode(new_value: bool) -> void:
	amen_mode = new_value
