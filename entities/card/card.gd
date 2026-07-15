class_name Card extends Node2D


@onready var main_animator: AnimationPlayer = $MainAnimator
@onready var sprite_root: Node2D = $SpriteRoot


var symbol: Utils.CardSymbol
var symbol_node: CardSymbol


func setup(card_data: CardData, cue_time: float, play_time: float, level_context: LevelContext) -> void:
	symbol = card_data.symbol
	symbol_node = card_data.symbol_scene.instantiate()
	symbol_node.setup(cue_time, play_time, level_context)
	sprite_root.add_child(symbol_node)

	symbol_node.symbol_hit.connect(on_symbol_hit)

	hide()


func spawn() -> void:
	show()
	main_animator.play("spawn")
	symbol_node.spawn()

func despawn() -> void:
	main_animator.stop(true)
	main_animator.play("despawn")
	symbol_node.despawn()


func on_symbol_hit(_symbol: CardSymbol, rating: Utils.HitRating) -> void:
	if rating == Utils.HitRating.MISS:
		main_animator.play("miss")
	else:
		main_animator.play("hit")
