extends Node2D

var tabs: Array[Array] = [[], [], [], []]
var spacing: Vector2

func _process(_delta: float) -> void:
	for t in range(4):
		for card in tabs[t]:
			card.rest_position = Vector2(spacing.x * t, 0)
