extends Attack

signal is_ready
const PillAreaScript = preload("res://Scripts/Attacks/PillArea.gd")
const DAMAGE_INCREASE = 0.25
const SPEED_INCREASE = 1.0
const COOLDOWN_REDUCTION = 0.25
const attack_type = "Pill"
var attack_data: Attack = null

class PillUpgrade:
	var apply
	func _init(_apply):
		apply = _apply

func _ready():
	
	pass

func initialize(_damage: int, _speed: float, _size: Vector2, _amount: int, _damage_type: String, _critical_chance_multiplier: float, _pierce: int, _duration: float, _cooldown: float, _attack_pool):
	print('init',_damage)
	damage = _damage
	speed = _speed
	size = _size
	amount = _amount
	damage_type = _damage_type
	critical_chance_multiplier = _critical_chance_multiplier
	pierce = _pierce
	duration = _duration
	cooldown = _cooldown
	attack_pool = _attack_pool
	upgrades = [
		PillUpgrade.new(func(attack): attack.damage *= 1 + DAMAGE_INCREASE),
		PillUpgrade.new(func(attack): attack.damage *= 1 + DAMAGE_INCREASE),
		PillUpgrade.new(func(attack): attack.damage *= 1 + DAMAGE_INCREASE),
		PillUpgrade.new(func(attack): attack.speed *= 1 + SPEED_INCREASE),
		PillUpgrade.new(func(attack): attack.speed *= 1 + SPEED_INCREASE),
		PillUpgrade.new(func(attack): attack.speed *= 1 + SPEED_INCREASE),
		PillUpgrade.new(func(attack): attack.cooldown *= 1 - COOLDOWN_REDUCTION),
		PillUpgrade.new(func(attack): attack.cooldown *= 1 - COOLDOWN_REDUCTION),
	]
	option_name = "Pill"
	description = "Throws a pill projectile to damage enemies."
	icon_path = "res://Assets/Images/Attack/pill.png"
	
func _spawn_attack(target_position, target_direction):
	var pill_instance = attack_pool.get_from_pool(attack_type, [damage, speed, size, amount, damage_type, critical_chance_multiplier, pierce, duration, cooldown])
	var angle_range = PI / 18
	var random_angle = randf_range(-angle_range, angle_range)
	var direction_with_recoil = target_direction.rotated(random_angle)
	
	pill_instance.position = target_position
	var current_scene = get_tree().current_scene
	current_scene.add_child(pill_instance)
	
	var pill_area = pill_instance.get_node("PillArea")
	pill_area.attack_data = self
	pill_area.direction = direction_with_recoil

func _on_ready():
	emit_signal("is_ready")
