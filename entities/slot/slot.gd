class_name Slot extends Node2D


var card: Card


func set_card(new_card: Card) -> void:
	discard()
	card = new_card
	add_child(card)


func discard() -> void:
	if card:
		card.despawn()