extends Character

const PillAttack = preload("res://Scenes/Attacks/Pill.tscn")
func _init(attack_pool):
	level = 1
	speed = 1000.0
	var damage = 25 	
	var size = Vector2(12, 12) 
	var amount = 1
	var damage_type = "normal"
	var critical_chance_multiplier = 1 
	var pierce = 1 
	var duration = 0.5
	var cooldown = 0.25
	initialize_starting_attack(damage, speed, size, amount, damage_type, critical_chance_multiplier, pierce, duration, cooldown, attack_pool)

func initialize_starting_attack(damage, speed, size, amount, damage_type, critical_chance_multiplier, pierce, duration, cooldown, attack_pool):
	starting_attack = PillAttack.instantiate() as Attack
#	await starting_attack.yield_to_signal("ready")
	await Signal(starting_attack, 'ready')
	starting_attack.initialize(damage, speed, size, amount, damage_type, critical_chance_multiplier, pierce, duration, cooldown, attack_pool)


#	await starting_attack.ready

#const FartAttack = preload("res://Scripts/Attacks/Fart.gd")
#func _init():
#	level = 1
#	speed = 1000.0
#	var damage = 25 	
#	var size = Vector2(12, 12) 
#	var amount = 1
#	var damage_type = "normal"
#	var critical_chance_multiplier = 1 
#	var pierce = 1 
#	var duration = 0.5
#	var cooldown = 0.25
#	starting_attack = FartAttack.new(damage,speed,size,amount,damage_type,critical_chance_multiplier,pierce,duration,cooldown)
