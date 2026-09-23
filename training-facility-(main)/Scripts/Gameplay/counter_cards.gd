extends Control

@onready var texter = $TextEdit
var current_cards: int

func _ready() -> void:
	current_cards = get_tree().get_nodes_in_group("card_pickup").size()
	GlobalBus.connect("card_picked", card_picked)
	texter.text = str(current_cards)
	GlobalBus.scan_levels()

func card_picked():
	current_cards -= 1
	if current_cards <= 0:
		GlobalBus.cards_depleted.emit()
	texter.text = str(current_cards)
