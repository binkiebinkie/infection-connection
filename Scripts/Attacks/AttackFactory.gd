# res://Scripts/Attacks/AttackFactory.gd - creates an initial version of an attack
class_name AttackFactory

func create_attack(attack_type: String, attack_pool, args = {}) -> Attack:
	var attack_instance = load("res://Scenes/Attacks/" + attack_type + ".tscn").instantiate()
	attack_instance.initialize(attack_pool, args)
	return attack_instance
