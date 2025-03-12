extends Node

const reds = [true, false, true, false]
const letters = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];
const shapes = ["♥", "♣", "♦", "♠"]

enum Location {
	Tableau,
	Stack,
	Discard,
	Foundations
}

func cards_in_order(top_card: Card, bottom_card: Card) -> bool:
	if top_card == null:
		return bottom_card.number == 13
	return top_card.number == bottom_card.number + 1  and  top_card.red != bottom_card.red
