class_name CardSymbolTomato extends CardSymbol


@onready var tomato_animator: AnimationPlayer = $TomatoAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0.75, cue))
	add_hit(HitData.new(0.75, 0, hit))


func cue() -> void:
	tomato_animator.stop(true)
	tomato_animator.play("cue")
	cue_sfx.play()


func hit() -> void:
	tomato_animator.stop(true)
	tomato_animator.play("hit")
	hit_sfx.play()
