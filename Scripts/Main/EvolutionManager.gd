class_name EvolutionManager

const MicrowaveAttack = preload("res://Scripts/Attacks/Microwave.gd")
const FartAttack = preload("res://Scripts/Attacks/Fart.gd")
const SizeModifier = preload("res://Scripts/Modifiers/Size.gd")
const CooldownModifier = preload("res://Scripts/Modifiers/Cooldown.gd")
const PierceModifier = preload("res://Scripts/Modifiers/Pierce.gd")
const DamageModifier = preload("res://Scripts/Modifiers/Damage.gd")

var evolve_options = [
	MicrowaveAttack.new(10, 150, Vector2(1, 1), 1, "hot", 1.0, 3, 5, 3),
	FartAttack.new(20, 100, Vector2(1, 1), 1, "poison", 1.0, 0, 5, 3),
	SizeModifier.new(),
	CooldownModifier.new(),
	PierceModifier.new(),
	DamageModifier.new()
	# Add more modifier and attack instances here
]

func get_random_options(num_options: int):
	var available_options = evolve_options.duplicate()
	var choices = []
	for _i in range(num_options):
		var choice = available_options[randi() % available_options.size()]
		choices.append(choice)
		available_options.erase(choice)
	return choices

func add_evolve_option(option):
	evolve_options.append(option)

func remove_evolve_option(option):
	evolve_options.erase(option)
	
func generate_evolve_options(player):
	var possible_options = evolve_options.duplicate()
	
	for attack in player.attacks:
		if not attack.fully_evolved:
			possible_options.append(attack)

	possible_options.shuffle()
	return possible_options.slice(0, 3)

