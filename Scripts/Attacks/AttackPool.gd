class_name AttackPool

var attack_pool = []

func add_to_pool(attack):
	attack.reset()
	attack_pool.append(attack)
	
func get_from_pool(attack_type: String, args = []) -> Attack:
	for attack in attack_pool:
		if attack.get("attack_type") == attack_type:
			attack_pool.erase(attack)
			return attack
	var attack_instance = load("res://Scenes/Attacks/" + attack_type + ".tscn").instantiate()
	if attack_instance.has_method("initialize"):
		attack_instance.initialize(args)
	return attack_instance

