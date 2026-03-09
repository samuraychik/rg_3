class_name Card extends Node2D


@onready var symbol_sprite: Sprite2D = %SymbolSprite
@onready var animator: AnimationPlayer = $Animator
@onready var rating_label: Label = $Rating


var spawn_beat: float

var cues: Array[float]
var hits: Array[float]

var next_cue: float
var next_hit: float

var symbol: Utils.CardSymbol


func setup(
	card_data: CardData,
	_spawn_beat: float,
	_cues: Array[float],
	_hits: Array[float]
	) -> void:
		spawn_beat = _spawn_beat
		cues = _cues
		hits = _hits
		symbol = card_data.symbol 
		symbol_sprite.hframes = len(hits) + 1
		symbol_sprite.texture = card_data.sprites

		set_next_hit()
		activate()
		hide()


func _physics_process(_delta: float) -> void:
	if not RhythmPlayer.playing:
		return

	if RhythmPlayer.current_beat >= spawn_beat:
		spawn()


func spawn() -> void:
	show()

func despawn() -> void:
	queue_free()

func activate() -> void:
	CueManager.cue.connect(on_cue)
	HitManager.hit.connect(on_hit)
	HitManager.miss.connect(on_miss)

func deactivate() -> void:
	CueManager.cue.disconnect(on_cue)
	HitManager.hit.disconnect(on_hit)
	HitManager.miss.disconnect(on_miss)


func set_next_hit() -> void:
	if hits.is_empty():
		deactivate()


func next_frame() -> void:
	symbol_sprite.frame += 1


func on_cue(cue: CueData) -> void:
	if cue.symbol == symbol and cues.has(cue.beat):
		animator.stop()
		animator.play("cue")

func on_hit(hit: HitData, rating: String) -> void:
	if hit.symbol == symbol and hits.has(hit.beat):
		rating_label.text = rating
		animator.stop()
		animator.play("hit")

func on_miss(miss: HitData) -> void:
	if miss.symbol == symbol and hits.has(miss.beat):
		animator.stop()
		animator.play("miss")
