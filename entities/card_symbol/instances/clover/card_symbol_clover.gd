class_name CardSymbolClover extends CardSymbol


@onready var clover_animator: AnimationPlayer = $CloverAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0.0, cue))
	add_hit(HitData.new(0.0, 0, hit))
	
	add_cue(CueData.new(0.25, cue))
	add_hit(HitData.new(0.25, 0, hit))
	
	add_cue(CueData.new(0.5, cue))
	add_hit(HitData.new(0.5, 0, hit))

	add_cue(CueData.new(0.75, cue))
	add_hit(HitData.new(0.75, 0, hit))


func cue() -> void:
	clover_animator.stop(true)
	clover_animator.play("cue")
	cue_sfx.play()


func hit() -> void:
	clover_animator.stop(true)
	clover_animator.play("hit")
	hit_sfx.play()
