extends Node2D

var stack: Array[Card] = []
var discard: Array[Card] = []
var last_discard_size: int = 0
var spacing: Vector2

func set_cards(card_set: Array[Card]):
	stack = card_set
	for card in stack:
		card.location = Main.Location.Stack
		card.disable_grab()
		card.name = card.format()
		add_child(card)
	$StackClick.move_to_front()
	
func _process(delta: float) -> void:
	for card in discard:
		Main.grabbed_on_top(card)
	
	if discard.size() == last_discard_size:
		return
	last_discard_size = discard.size()
	for card in discard.slice(0, -1):
		card.disable_grab()
	if last_discard_size > 0:
		discard.back().enable_grab()

func _on_stack_clicked() -> void:
	if stack.is_empty():
		stack.append_array(discard)
		stack.reverse()
		discard.clear()
		for card in stack:
			card.location = Main.Location.Stack
			card.rest_position = Vector2.ZERO
			card.unreveal()
		$StackClick.move_to_front()
		return
	else:
		var card: Card = stack.pop_back()
		discard.push_back(card)
		card.move_to_front()
		card.location = Main.Location.Discard
		card.rest_position = Vector2(spacing.x, 0)
		card.row = discard.size()
		card.reveal()
