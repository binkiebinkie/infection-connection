# res://Scripts/Main/EvolveOption.gd - can be type Attack or Modifier, manages leveling and the text that displays
class_name EvolveOption
extends Node2D

var option_name: String
var description: String
var level: int = 1
var max_level: int = 8
var icon_path = "res://Assets/Images/Modifiers/IconCooldown.png"

func apply(player):
	pass

func level_up():
	level += 1
	if level > max_level:
		level = max_level

func get_icon() -> Texture:
	return load(icon_path)
