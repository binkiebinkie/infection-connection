class_name BaseAttack
extends EvolveOption

var damage: int
var speed: float
var size: Vector2
var amount: int
var damage_type: String
var critical_chance_multiplier: float
var pierce: int
var duration: int
var cooldown: int

func _init(_damage: int, _speed: float, _size: Vector2, _amount: int, _damage_type: String, _critical_chance_multiplier: float, _pierce: int, _duration: int, _cooldown: int):
	damage = _damage 
	speed = _speed # Int for how fast
	size = _size # Multiplier for scale
	amount = _amount # Duplication, number of instances
	damage_type = _damage_type # 
	critical_chance_multiplier = _critical_chance_multiplier
	pierce = _pierce
	duration = _duration
	cooldown = _cooldown

func activate(target_position, target_direction):
	pass


func _on_evolution_button_pressed():
	pass # Replace with function body.
