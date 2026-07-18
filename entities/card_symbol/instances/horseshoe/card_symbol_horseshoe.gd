class_name CardSymbolHorseshoe extends CardSymbol


@onready var horseshoe_animator: AnimationPlayer = $HorseshoeAnimator
@onready var flip_sfx: AudioStreamPlayer = $FlipSFX


func on_spawn() -> void:
	add_cue(CueData.new(0.0, cue))
	if randf() < 0.5:
		add_hit(HitData.new(0.0, 0.0, hit))
	else:
		add_cue(CueData.new(0.5, flip))
		add_hit(HitData.new(0.5, 0.0, hit))


func cue() -> void:
	horseshoe_animator.stop(true)
	horseshoe_animator.play("cue")
	cue_sfx.play()


func flip() -> void:
	horseshoe_animator.stop(true)
	horseshoe_animator.play("flip")
	flip_sfx.play()


func hit() -> void:
	horseshoe_animator.stop(true)
	horseshoe_animator.play("hit")
	hit_sfx.play()