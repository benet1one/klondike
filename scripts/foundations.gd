extends Node2D

var spacing: Vector2
var tabs: Array[Array] = [[], [], [], []]
var last_tab_size: Array[int] = [0, 0, 0, 0]

func _process(_delta: float) -> void:
	for t in range(4):
		for card in tabs[t]:
			card.rest_position = Vector2(spacing.x * t, 0)
			Main.grabbed_on_top(card)
		
		if tabs[t].size() != last_tab_size[t]:
			last_tab_size[t] = tabs[t].size()
			for card in tabs[t].slice(0, -1):
				card.disable_grab()
			if not tabs[t].is_empty():
				tabs[t].back().enable_grab()

func game_won() -> bool:
	for t in tabs:
		if t.size() < 13:
			return false
	return true
