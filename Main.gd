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

func grabbed_on_top(card: Card):
	if card.grabbed:
		card.z_index = 1
	else:
		card.z_index = 0
