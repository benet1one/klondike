extends Node2D

var card_scene: PackedScene = load("res://card.tscn")
var card_set: Array[Card]

var spacing: Vector2 = Vector2(80, 22)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_and_split_cards()
	$Stack.spacing = self.spacing
	$Tableau.spacing = self.spacing
	$Foundations.spacing = self.spacing
	$Foundations.position.y = $Stack.position.y
	$Foundations.position.x = $Stack.position.x + 3 * spacing.x

func generate_and_split_cards() -> void:
	for s in range(4):
		for n in range(13):
			var card = card_scene.instantiate()
			card.number = n + 1
			card.shape = s
			card.red = Main.reds[s]
			card.connect("move", _on_card_move)
			card_set.push_back(card)
			
	card_set.shuffle()
	var tableau_cards = card_set.slice(0, 28)
	var stack_cards = card_set.slice(28, 13*4)
	
	$Tableau.set_cards(tableau_cards)
	$Stack.set_cards(stack_cards)

func _on_card_move(card: Card) -> bool:
	print("Card " + card.format() + " attempting move")
	if card.global_position.y > $Tableau.position.y - 20:
		return move_to_tableau(card)
	else:
		return move_to_foundation(card)

func move_to_tableau(card: Card) -> bool:
	var from = card.location
	if not $Tableau.move_card(card):
		return false
	
	if from == Main.Location.Discard:
		$Stack.discard.pop_back()
	if from == Main.Location.Foundations:
		$Foundations.tabs[card.shape].pop_back()
	return true

func move_to_foundation(card: Card) -> bool:
	if card.location == Main.Location.Foundations:
		print("Attempt to move Foundations -> Foundations")
		return false
	
	if card.location == Main.Location.Tableau  and  card != $Tableau.tabs[card.tab].back():
		print("Failed to move Tableau -> Foundations: Card is not last in tab.")
		return false
		
	if card.number != 1:
		if $Foundations.tabs[card.shape].is_empty():
			print("Failed to move to Foundations: No cards of shape.")
			return false
		var last_card: Card = $Foundations.tabs[card.shape].back()
		if card.number != last_card.number + 1:
			print("Failed to move to Foundations: Missing previous card of shape.")
			return false
		
	$Foundations.tabs[card.shape].push_back(card)
	
	if card.location == Main.Location.Discard:
		print("Successful move Discard -> Foundations")
		$Stack.discard.pop_back()
	else:
		print("Successful move Tableau -> Foundations")
		$Tableau.tabs[card.tab].pop_back()

	card.reparent($Foundations)	
	card.location = Main.Location.Foundations
	card.tab = card.shape
	card.row = card.number - 1

	return true


func _on_discard_click() -> void:
	pass # Replace with function body.
