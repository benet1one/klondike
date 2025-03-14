extends Node2D

var game_scene: PackedScene = load("res://scenes/game.tscn")

func new_game() -> void:
	$Game.free()
	var newgame = game_scene.instantiate()
	newgame.name = "Game"
	newgame.connect("win", _on_game_won)
	add_child(newgame)
	$Overlay.move_to_front()

func _on_new_game_pressed() -> void:
	new_game()

func _on_game_won() -> void:
	print("GAME WON OMG OMG")
