class_name CardSymbolHearts extends CardSymbol


@onready var hearts_animator: AnimationPlayer = $HeartsAnimator
@onready var hit_final_sfx: AudioStreamPlayer = $HitFinalSfx


var hit_timings: Array[float] = [0.5]


func on_spawn() -> void:
  level_context.full_pattern.connect(on_full_pattern)
  add_cue(CueData.new(0.5, cue))
  
  
func cue() -> void:
  cue_sfx.play()
  hearts_animator.stop(true)
  hearts_animator.play("cue")


func hit() -> void:
  hit_sfx.play()
  hearts_animator.stop(true)
  hearts_animator.play("hit")


func hit_final() -> void:
  hit_final_sfx.play()
  hearts_animator.stop(true)
  hearts_animator.play("hit_final")


func on_full_pattern() -> void:
  for card in level_context.slots:
    if card == null:
      continue
	  
    match card.symbol:
      Utils.CardSymbol.SUIT_SPADES:
        hit_timings.push_back(0.0)
      Utils.CardSymbol.SUIT_CLUBS:
        hit_timings.push_back(0.25)
      Utils.CardSymbol.SUIT_DIAMONDS:
        hit_timings.push_back(0.75)
  hit_timings.sort()

  var hit_count = hit_timings.size()
  for i in range(hit_count):
    if i == hit_count - 1:
      add_hit(HitData.new(hit_timings[i], 0.0, hit_final))
    else:
      add_hit(HitData.new(hit_timings[i], 0.0, hit))
