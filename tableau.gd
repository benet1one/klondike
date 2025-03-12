extends Node2D

var tabs: Array[Array] = [[]]
var spacing: Vector2

# Called when the node enters the scene tree for the first time.
func set_cards(card_set: Array[Card]) -> void:
	var i = 0
	for t in range(7):
		if t > 0:
			tabs.push_back([])
		for u in range(t + 1):
			var card = card_set[i]
			card.rest_position = Vector2(spacing.x * t, spacing.y * u)
			card.location = Main.Location.Tableau
			card.tab = t
			card.row = u
			card.name = card.format()
			add_child(card)
			tabs.back().push_back(card)
			i += 1
			
	for t in tabs:
		t.back().reveal()

func _process(_delta: float) -> void:
	var i: int = 0
	for t in tabs:
		var z: int = 0
		for card in t:
			move_child(card, i)
			i += 1
			if card.grabbed:
				z = 1
			card.z_index = z
	
	for t in range(7):
		var n_cards = tabs[t].size()
		if n_cards > 0:
			tabs[t].back().reveal()
			tabs[t][0].rest_position = Vector2(t * spacing.x, 0)
		
		for u in range(1, n_cards):
			var adjusted_spacing: int = spacing.y
			if n_cards > 10:
				adjusted_spacing = int(spacing.y * 10 / n_cards)
			tabs[t][u].rest_position = tabs[t][u - 1].position + Vector2(0, adjusted_spacing)

func debug_print() -> void:
	for t in tabs:
		print("\n")
		for card in t:
			print(card.format() + " ")

func cards_in_order(top_card: Card, bottom_card: Card) -> bool:
	if top_card == null:
		return bottom_card.number == 13
	return top_card.number == bottom_card.number + 1  and  top_card.red != bottom_card.red

func is_card_movable(card: Card) -> bool:
	if card.location != Main.Location.Tableau:
		return true
	
	var t = card.tab
	var u = card.row
	
	for k in range(u + 1, tabs[t].size()):
		if !cards_in_order(tabs[t][k - 1], tabs[t][k]):
			return false
	return true

func lower_cards(t: int, u: int) -> Array[Card]:
	return tabs[t].slice(u + 1)

func move_card(card: Card) -> bool:
	var t: int = roundi(
		(card.global_position.x - self.global_position.x) / spacing.x
	)
	t = min(6, t)
	t = max(0, t)
	
	if not is_card_movable(card):
		print("Card stack not movable")
		return false
		
	var top_card: Card
	if tabs[t].is_empty():
		top_card = null
	else:
		top_card = tabs[t].back()
	
	if not cards_in_order(top_card, card):
		print("Cards not in order")
		return false
	
	if card.location == Main.Location.Tableau:
		if t == card.tab:
			print("Attempt to move card to same position")
			return false
			
		var cards_moved = tabs[card.tab].slice(card.row)
		tabs[t].append_array(cards_moved)
		
		var t_from = card.tab
		var u_from = card.row
		
		for u in range(tabs[t].size()):
			tabs[t][u].tab = t
			tabs[t][u].row = u

		tabs[t_from] = tabs[t_from].slice(0, u_from)
		
		print("Successful move: Tableau -> Tableau")
		return true
	
	else:
		card.reparent(self)
		tabs[t].push_back(card)
		card.location = Main.Location.Tableau
		card.tab = t
		card.row = tabs[t].size() - 1
		
		print("Successful move: Elsewhere -> Tableau")
		return true
