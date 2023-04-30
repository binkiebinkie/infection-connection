extends Character

const PillAttack = preload("res://Scripts/Attacks/Pill.gd")

func _init():
	level = 1
	speed = 1000.0
	var damage = 25 	
	var size = Vector2(12, 12) 
	var amount = 1 
	var damage_type = "normal"
	var critical_chance_multiplier = 1 
	var pierce = 1 
	var duration = 0.5
	var cooldown = 1.0
	starting_attack = PillAttack.new(damage,speed,size,amount,damage_type,critical_chance_multiplier,pierce,duration,cooldown)
