class_name Card extends Node2D


signal symbol_hit(symbol: CardSymbol, rating: Utils.HitRating)


@onready var main_animator: AnimationPlayer = $MainAnimator
@onready var sprite_root: Node2D = $SpriteRoot


var symbol_node: CardSymbol


func setup(card_data: CardData, card_context: CardContext, level_context: LevelContext) -> void:
	symbol_node = card_data.symbol_scene.instantiate()
	symbol_node.setup(card_context, level_context)
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


func on_symbol_hit(symbol: CardSymbol, rating: Utils.HitRating) -> void:
	symbol_hit.emit(symbol, rating)
	if rating == Utils.HitRating.MISS:
		main_animator.play("miss")
