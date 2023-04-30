# Pill.gd
extends Attack
const PillAttack = preload("res://Scenes/Attacks/Pill.tscn")

const DAMAGE_INCREASE = 0.25
const SPEED_INCREASE = 1.0
const COOLDOWN_REDUCTION = 0.25
var attack_data: Attack = null

class PillUpgrade:
	var apply
	func _init(_apply):
		apply = _apply

func _init(_damage: int, _speed: float, _size: Vector2, _amount: int, _damage_type: String, _critical_chance_multiplier: float, _pierce: int, _duration: float, _cooldown: float):
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
	
func _on_projectile_duration_reached(attack_instance):
	print("duratiion reached attack")
	if attack_instance == attack_data:
		queue_free()

func _spawn_attack(target_position, target_direction):
	var pill_scene = load("res://Scenes/Attacks/Pill.tscn")
	var pill_instance = pill_scene.instantiate()
	
	var angle_range = PI / 18
	var random_angle = randf_range(-angle_range, angle_range)
	var direction_with_recoil = target_direction.rotated(random_angle)

	pill_instance.position = target_position
	pill_instance.direction = direction_with_recoil
	pill_instance.attack_data = self
	
	var current_scene = Global.get_current_scene()
	current_scene.add_child(pill_instance)

