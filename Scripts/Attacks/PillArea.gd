# res://Scripts/Attacks/PillArea.gd - child Area2D of Pill Node2D
extends Area2D
var direction: Vector2 = Vector2()
var attack_data: Attack = null

func initialize(_attack_data, _direction):
	self.attack_data = _attack_data
	self.direction = _direction
