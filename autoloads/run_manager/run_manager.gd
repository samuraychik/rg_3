extends Node


const LEVEL_SCENE = preload("uid://vm334jqbvcui")
const CHOICE_SCENE = preload("uid://fi071o5s7os0")
const START_SCENE = preload("uid://duudfofpgv5ik")

var deck: DeckData


func start_run(starting_deck: DeckData, level: LevelData) -> void:
	deck = starting_deck.duplicate_deep()
	start_level(level)
	

func start_level(level: LevelData) -> void:
	get_tree().change_scene_to_packed(LEVEL_SCENE)
	await get_tree().scene_changed
	var level_scene = get_tree().current_scene
	level_scene.setup(deck, level)
	RhythmPlayer.play()


func finish_level() -> void:
	RhythmPlayer.stop()
	get_tree().change_scene_to_packed(START_SCENE)
