class_name Card extends Node2D


signal symbol_hit(symbol: CardSymbol, rating: Utils.HitRating)


@onready var main_animator: AnimationPlayer = $MainAnimator
@onready var sprite_root: Node2D = $SpriteRoot
@onready var miss_sfx: AudioStreamPlayer = $MissSfx


var symbol_node: CardSymbol


func setup(card_data: CardData, slot_id: int, cue_base: int, hit_base: int, level_context: LevelContext) -> void:
	symbol_node = card_data.symbol_scene.instantiate()
	symbol_node.setup(slot_id, cue_base, hit_base, level_context)
	sprite_root.add_child(symbol_node)

	symbol_node.symbol_hit.connect(on_symbol_hit)
	level_context.jackpot.connect(on_jackpot)

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
		miss_sfx.play()


func on_jackpot() -> void:
	main_animator.play("jackpot")
