class_name Slot extends Node2D


var cards_queue: Array[Card]
var card: Card


func add_card(new_card: Card) -> void:
	cards_queue.push_front(new_card)
	add_child(new_card)


func set_card(new_card: Card) -> void:
	card = new_card
	

func next() -> void:
	if cards_queue.is_empty():
		return
	
	if card:
		card.despawn()
	set_card(cards_queue.pop_back())
