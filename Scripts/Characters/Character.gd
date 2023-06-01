# res://Scripts/Characters/Character.gd
class_name Character
extends Node2D

var player: Node2D
var speed: float = 1000.0
var health: int = 100
var level: int = 1
var starting_attack

# store the attack instances associated with a particular character
# i.e. starting attacks or unlocked attacks
var attacks = []
var last_non_zero_input_direction: Vector2 = Vector2(1,0)
var attack_duration_timer: Timer

func initialize(player: Node2D):
	self.player = player

func get_input_direction() -> Vector2:
	return Vector2.ZERO

func add_attack(attack_instance: Attack):
	print('character attack_isntance ',attack_instance)
	attacks.append(attack_instance)
	attack_instance.activate(self)

func set_last_non_zero_input_direction(direction: Vector2) -> void:
	last_non_zero_input_direction = direction.normalized()
