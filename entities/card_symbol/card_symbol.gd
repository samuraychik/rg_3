class_name CardSymbol extends Node2D


@onready var sprite: Sprite2D = $Sprite
@onready var cue_player: AudioStreamPlayer = %CuePlayer
@onready var hit_player: AudioStreamPlayer = %HitPlayer
@onready var main_animator: AnimationPlayer = %MainAnimator

var cue_state := 0
var hit_state := 0


func apply_curses(curses: Array[Utils.Curse]) -> void:
	for curse: Utils.Curse in curses:
		match curse:
			Utils.Curse.MUTED:
				sprite.material = preload("uid://dnx1imyh45jhm")
				cue_player.volume_db = -80
			_:
				pass


func spawn() -> void:
	main_animator.play("spawn")


func despawn() -> void:
	main_animator.play("despawn")


func next_cue() -> void:
	cue_state += 1


func next_hit() -> void:
	hit_state += 1


func next_frame() -> void:
	sprite.frame += 1
