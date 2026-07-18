class_name LevelContext extends Resource


signal full_pattern
signal card_drawn
signal jackpot


var windows: WindowsData

var deck: Array[CardData]
var draw_pile: Array[CardData]
var slots: Array[CardData]


func draw() -> CardData:
  if draw_pile.is_empty():
    draw_pile = deck.duplicate()
    draw_pile.shuffle()
  return draw_pile.pop_back()
