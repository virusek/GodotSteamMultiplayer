extends Node

@export var game_scene: PackedScene

func start_game():
	get_tree().change_scene_to_packed(game_scene)
