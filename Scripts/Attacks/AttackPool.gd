class_name AttackPool

var attack_pool = []

func add_to_pool(attack):
	attack.reset()
	attack_pool.append(attack)

func get_from_pool(attack_class, args = []) -> Attack:
	for attack in attack_pool:
		if attack.is_instance_of(attack_class):
			attack_pool.erase(attack)
			return attack
	
	return attack_class.callv("new", args)
