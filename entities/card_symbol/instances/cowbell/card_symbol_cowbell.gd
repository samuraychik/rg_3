class_name CardSymbolCowbell extends CardSymbol


@onready var cowbell_animator: AnimationPlayer = $CowbellAnimator


func next_cue() -> void:
	cowbell_animator.stop(true)
	cowbell_animator.play("cue")
	cue_player.play()
	super()


func next_hit() -> void:
	cowbell_animator.stop(true)
	cowbell_animator.play("hit")
	hit_player.play()
	super()
