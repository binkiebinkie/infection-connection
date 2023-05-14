# res://Scripts/Global.gd
extends Node
var DefaultAttacks = preload("res://Scenes/Attacks/DefaultAttacks.gd").new()
var selected_character

func get_current_scene():
	return get_tree().get_current_scene()

#hey ChatGPT I am trying to make a mobile 2d game using Godot version 4. I have a Player that has one or serveral Attacks that fire constantly. The Attack should shoot in the direction the player is facing at the time of the Attack every `cooldown` interval. I am currently having an issue with the Pill instance; as the Player rotates the Pills x and y position will change to the direction the Player is facing. Any ideas as to why this is happening?
