# res://Scripts/Attacks/AttackFactory.gd - creates an initial version of an attack
class_name AttackFactory

func create_attack(attack_type: String, args = {}) -> Attack:
	var attack_instance = load("res://Scenes/Attacks/" + attack_type + ".tscn").instantiate()
	attack_instance.initialize(args)
	print('create_attack args',args)
	attack_instance._spawn_attack()
	return attack_instance
