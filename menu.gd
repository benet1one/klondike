extends Node2D

var game_scene: PackedScene = load("res://game.tscn")

func new_game() -> void:
	$Game.free()
	var newgame = game_scene.instantiate()
	newgame.name = "Game"
	add_child(newgame)
	$Overlay.move_to_front()

func _on_new_game_pressed() -> void:
	new_game()
