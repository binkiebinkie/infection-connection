extends Attack

const FartAttack = preload("res://Scripts/Attacks/Fart.gd")

const DURATION_INCREASE = 0.5
const DAMAGE_INCREASE = 0.25
const AREA_INCREASE = 0.5
const COOLDOWN_REDUCTION_1 = 0.25
const SPEED_INCREASE = 1.0
const COOLDOWN_REDUCTION_2 = 0.25
var direction: Vector2
const attack_type = "Fart"

class FartUpgrade:
	var apply
	func _init(_apply):
		apply = _apply
		
func _process(delta):
	position += direction * speed * delta

func _init(_damage: int, _speed: float, _size: Vector2, _amount: int, _damage_type: String, _critical_chance_multiplier: float, _pierce: int, _duration: int, _cooldown: int, _attack_pool):
	attack_pool = _attack_pool
	upgrades = [
		FartUpgrade.new(func(attack): attack.duration *= 1 + DURATION_INCREASE),
		FartUpgrade.new(func(attack): attack.damage *= 1 + DAMAGE_INCREASE),
		FartUpgrade.new(func(attack): attack.size *= 1 + AREA_INCREASE),
		FartUpgrade.new(func(attack): attack.cooldown *= 1 - COOLDOWN_REDUCTION_1),
		FartUpgrade.new(func(attack): attack.speed *= 1 + SPEED_INCREASE),
		FartUpgrade.new(func(attack):
			var new_fart = FartAttack.new(attack.damage, attack.speed, attack.size, attack.amount, attack.damage_type, attack.critical_chance_multiplier, attack.pierce, attack.duration, attack.cooldown, attack_pool)
			new_fart.global_position = attack.global_position.rotated(deg_to_rad(45))
			get_parent().add_child(new_fart)),
		FartUpgrade.new(func(attack): attack.size *= 1 + AREA_INCREASE),
		FartUpgrade.new(func(attack): attack.cooldown *= 1 - COOLDOWN_REDUCTION_2),
	]
	
	option_name = "Fart"
	description = "Poot poooot, poison cloud incoming"
	icon_path = "res://Assets/Images/Attack/fart.png"

#func activate(target_position, target_direction, player):
#	super.activate(target_position, target_direction, player)
#	_spawn_attack(target_position, target_direction, player)
#
#func _spawn_attack(position, direction, player):
#	print('attack_pool',attack_pool)
#	var fart_instance = attack_pool.get_from_pool(attack_type, [damage, speed, size, amount, damage_type, critical_chance_multiplier, pierce, duration, cooldown])
#
#	fart_instance.position = position
#	fart_instance.direction = direction
#	fart_instance.duration = duration
#	fart_instance.damage = damage
#	fart_instance.speed = speed
##	fart_instance.attack_data = self
#
#	var current_scene = Global.get_current_scene()
#	current_scene.add_child(fart_instance)
