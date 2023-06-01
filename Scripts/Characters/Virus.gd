# res://Scripts/Characters/Virus.gd - Character type instance
extends Character
var AttackFactory = preload("res://Scripts/Attacks/AttackFactory.gd").new()

func _init():
	level = 1
	speed = 1000.0
	starting_attack = AttackFactory.create_attack("Pill", Global.DefaultAttacks.DEFAULT_PILL_ATTACKS)


#extends Character
#var PillAttackFactory = preload("res://Scripts/Attacks/PillAttackFactory.gd").new()
#var attack_pool
#func _init(_attack_pool = []):
#	level = 1
#	speed = 1000.0
#	attack_pool = _attack_pool
#	starting_attack = PillAttackFactory.create_pill_attack(_attack_pool)
#	starting_attack.damage = damage
#	starting_attack.speed = speed
#	starting_attack.size = size
#	starting_attack.amount = amount
#	starting_attack.damage_type = damage_type
#	starting_attack.e = critical_chance_multiplier
#	starting_attack.pierce = pierce
#	starting_attack.duration = duration
#	starting_attack.cooldown = cooldown
#	starting_attack.attack_pool = _attack_pool
	
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
