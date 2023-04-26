# EvolveOption.gd

class_name EvolveOption
extends Node2D

var option_name: String
var description: String
var level: int = 1
var max_level: int = 8

func apply(player):
	pass

func level_up():
	level += 1
	if level > max_level:
		level = max_level
