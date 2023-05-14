# AttackPool.gd - keeps track of all the active attacks - child of Player
extends Node2D
class_name AttackPool
var attack_pool = []

func add_to_pool(attack):
	print('attack pool adding attack',attack)
	attack.reset()
	attack_pool.append(attack)

func get_from_pool(attack_type: String) -> Array:
	for attack in attack_pool:
		if attack.get("attack_type") == attack_type:
			attack_pool.erase(attack)
			return [attack, self]
	var attack_instance = load("res://Scenes/Attacks/" + attack_type + ".tscn").instantiate()
	return [attack_instance, self]  
