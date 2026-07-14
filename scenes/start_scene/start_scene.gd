class_name StartScene extends Control


const APPLE_DECK = preload("uid://do8p2y1x61486")


func _on_button_pressed() -> void:
	RunManager.start_run(APPLE_DECK)
