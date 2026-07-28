class_name StartScene extends Control


const DECKS: Array[DeckData] = [preload("uid://do8p2y1x61486"), preload("uid://b3cmum2520eai"), preload("uid://cajstxrvbrjx1"), preload("uid://cbvbwl0wxt0kd")]
var current_deck: DeckData = DECKS[0]


func _on_button_1_pressed() -> void:
	RunManager.start_run(current_deck, preload("uid://cgrwsn47t2h4p"))


func _on_button_2_pressed() -> void:
	RunManager.start_run(current_deck, preload("uid://bgd0ngku5hmjs"))


func _on_button_3_pressed() -> void:
	RunManager.start_run(current_deck, preload("uid://dy4ue833d6q3y"))


func _on_option_button_item_selected(index: int) -> void:
	current_deck = DECKS[index]
