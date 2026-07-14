class_name Card extends Node2D


@onready var main_animator: AnimationPlayer = $MainAnimator
@onready var sprite_root: Node2D = $SpriteRoot
@onready var dirt_sprite: Sprite2D = $SpriteRoot/DirtSprite


var active: bool = false
var spawned: bool = false
var spawn_beat: float
var despawn_beat: float

var cues: Array[float]
var hits: Array[float]

var next_cue: float
var next_hit: float

var symbol: Utils.CardSymbol
var symbol_node: CardSymbol


func setup(
	card_data: CardData,
	_spawn_beat: float,
	_despawn_beat: float,
	_cues: Array[float],
	_hits: Array[float],
	amen_mode: bool = false,
	) -> void:
		# Timings
		spawn_beat = _spawn_beat
		despawn_beat = _despawn_beat
		cues = _cues
		hits = _hits

		# Symbol creation
		symbol = card_data.symbol
		symbol_node = card_data.symbol_scene.instantiate()
		sprite_root.add_child(symbol_node)
		
		# Curses
		apply_curses(card_data.curses)
		symbol_node.apply_curses(card_data.curses)
		
		# Amen Jackpot
		if amen_mode and symbol_node is CardSymbolSeven:
			symbol_node.set_amen_mode(true)

		set_next_hit()
		activate()
		hide()

func apply_curses(curses: Array[Utils.Curse]) -> void:
	for curse: Utils.Curse in curses:
		match curse:
			Utils.Curse.DIRTY:
				dirt_sprite.show()
			_:
				pass


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing:
		return

	if not spawned and RhythmPlayer.current_beat >= spawn_beat:
		spawned = true
		spawn()
	
	if spawned and RhythmPlayer.current_beat >= despawn_beat:
		queue_free()


func spawn() -> void:
	show()
	main_animator.play("spawn")
	symbol_node.spawn()

func despawn() -> void:
	main_animator.stop(true)
	main_animator.play("despawn")
	symbol_node.despawn()
	if dirt_sprite.visible:
		dirt_sprite.hide()

func activate() -> void:
	active = true
	CueManager.cue.connect(on_cue)
	HitManager.hit.connect(on_hit)
	HitManager.miss.connect(on_miss)

func deactivate() -> void:
	active = false
	CueManager.cue.disconnect(on_cue)
	HitManager.hit.disconnect(on_hit)
	HitManager.miss.disconnect(on_miss)


func set_next_hit() -> void:
	if hits.is_empty() and active:
		deactivate()


func on_cue(cue: CueData) -> void:
	if cue.symbol == symbol and cues.has(cue.beat):
		symbol_node.next_cue()

func on_hit(hit: HitData, _rating: String) -> void:
	if hit.symbol == symbol and hits.has(hit.beat):
		main_animator.play("hit")
		symbol_node.next_hit()

func on_miss(miss: HitData, _late) -> void:
	if miss.symbol == symbol and hits.has(miss.beat):
		main_animator.play("miss")
