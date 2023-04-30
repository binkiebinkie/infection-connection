# Global.gd

extends Node

var selected_character = preload("res://Scripts/Characters/Virus.gd")

func get_current_scene():
	return get_tree().get_current_scene()
