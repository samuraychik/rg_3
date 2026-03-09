class_name Slot extends Node2D


var card: Card


func set_card(new_card: Card) -> void:
	card = new_card
	add_child(card)


func clear() -> void:
	remove_child(card)
	card.despawn()
