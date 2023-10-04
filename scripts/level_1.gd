extends Node2D

@export() var coins_to_win: int = 0

func get_coins():
	return coins_to_win

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://you_win.tscn")
