class_name CardSymbolCowbell extends CardSymbol


@onready var cowbell_animator: AnimationPlayer = $CowbellAnimator


func on_spawn() -> void:
	add_cue(CueData.new(0.0, cue))
	add_hit(HitData.new(0.0, 0, hit))

	add_cue(CueData.new(0.75, cue))
	add_hit(HitData.new(0.75, 0, hit))


func cue() -> void:
	cowbell_animator.stop(true)
	cowbell_animator.play("cue")
	cue_sfx.play()


func hit() -> void:
	cowbell_animator.stop(true)
	cowbell_animator.play("hit")
	hit_sfx.play()
