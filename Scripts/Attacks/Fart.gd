extends UpgradeableAttack

const FartAttack = preload("res://Scripts/Attacks/Fart.gd")

const DURATION_INCREASE = 0.5
const DAMAGE_INCREASE = 0.25
const AREA_INCREASE = 0.5
const COOLDOWN_REDUCTION_1 = 0.25
const SPEED_INCREASE = 1.0
const COOLDOWN_REDUCTION_2 = 0.25

class FartUpgrade:
	var apply
	func _init(_apply):
		apply = _apply

func _init(_damage: int, _speed: float, _size: Vector2, _amount: int, _damage_type: String, _critical_chance_multiplier: float, _pierce: int, _duration: int, _cooldown: int):
	damage = _damage
	speed = _speed
	size = _size
	amount = _amount
	damage_type = _damage_type
	critical_chance_multiplier = _critical_chance_multiplier
	pierce = _pierce
	duration = _duration
	cooldown = _cooldown
	
	upgrades = [
		FartUpgrade.new(func(attack): attack.duration *= 1 + DURATION_INCREASE),
		FartUpgrade.new(func(attack): attack.damage *= 1 + DAMAGE_INCREASE),
		FartUpgrade.new(func(attack): attack.size *= 1 + AREA_INCREASE),
		FartUpgrade.new(func(attack): attack.cooldown *= 1 - COOLDOWN_REDUCTION_1),
		FartUpgrade.new(func(attack): attack.speed *= 1 + SPEED_INCREASE),
		FartUpgrade.new(func(attack):
			var new_fart = FartAttack.new(attack.damage, attack.speed, attack.size, attack.amount, attack.damage_type, attack.critical_chance_multiplier, attack.pierce, attack.duration, attack.cooldown)
			new_fart.global_position = attack.global_position.rotated(deg_to_rad(45))
			get_parent().add_child(new_fart)),
		FartUpgrade.new(func(attack): attack.size *= 1 + AREA_INCREASE),
		FartUpgrade.new(func(attack): attack.cooldown *= 1 - COOLDOWN_REDUCTION_2),
	]

func activate(target_position, target_direction):
	spawn_fart(target_position, -target_direction)

func spawn_fart(position, direction):
	var fart_scene = load("res://Scenes/Attacks/Fart.tscn")
	var fart_instance = fart_scene.instance()
	
	fart_instance.position = position
	fart_instance.direction = direction
	fart_instance.duration = duration
	fart_instance.damage = damage
	fart_instance.speed = speed
	
	get_parent().add_child(fart_instance)
