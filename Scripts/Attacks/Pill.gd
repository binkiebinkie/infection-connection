# res://Scenes/Attacks/Pill.tscn - Pill.gd, Attack instance 
extends Attack
signal is_ready
const PillAreaScript = preload("res://Scripts/Attacks/PillArea.gd")
const DAMAGE_INCREASE = 0.25
const SPEED_INCREASE = 1.0
const COOLDOWN_REDUCTION = 0.25
const attack_type = "Pill"
var attack_data: Attack = null
var linear_velocity
var direction: Vector2 = Vector2.ZERO

class PillUpgrade:
	var apply
	func _init(_apply):
		apply = _apply

func _init() -> void:
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
	print('pill initializinga')
	option_name = "Pill"
	description = "Throws a pill projectile to damage enemies."
	icon_path = "res://Assets/Images/Attack/pill.png"

func _on_ready():
	var player = get_node("/root/Game/Player")
	var character = player.character
	print('pill ready, initializing, _on_ready')
	character.initialize(player)
	emit_signal("is_ready")
	
func _spawn_attack(player, attack_pool):
	print('_spawn',_spawn_attack)
	print('_spawn_attack inside _spawn_attack',damage, speed, size,amount, damage_type, critical_chance_multiplier, pierce, duration, cooldown)
	var attack_instance_data = attack_pool.get_from_pool(attack_type)
	var pill_instance = attack_instance_data[0]
	print('pill_instance',pill_instance)
	var parent_node = attack_instance_data[1]
	var angle_range = PI / 18
	var random_angle = randf_range(-angle_range, angle_range)
	print(' player.get_direction()', player.get_direction())
	direction = player.get_direction().rotated(random_angle)
	print('direction',direction)
	if pill_instance.get_parent() != null:
		pill_instance.get_parent().remove_child(pill_instance)

	attack_pool.add_child(pill_instance)
	pill_instance.position = player.global_position
	pill_instance.attack_data = pill_instance.initialize(attack_pool, {"damage":damage, "speed":speed, "size":size, "amount":amount, "damage_type":damage_type, "critical_chance_multiplier":critical_chance_multiplier, "pierce":pierce, "duration":duration, "cooldown":cooldown})
	print('speed', speed)
	pill_instance.linear_velocity = direction.normalized() * speed
	_attach_duration_expiration(pill_instance)
	
func _on_projectile_duration_reached(pill):
	print('pill DELTETLETLE', pill)
	
func _attach_duration_expiration(pill):
	print('rudation,',duration)
	$DurationTimer.set_wait_time(duration)
#	$DurationTimer.connect("timeout", _on_projectile_duration_reached.bind(pill))
	print('_on_projectile_duration_reached')
	$DurationTimer.start()
	
func _physics_process(delta: float) -> void:
#	print(direction)
	if direction == Vector2.ZERO:
		return
	position += direction * speed * delta

# chatgpt If you look at the AttackPool does it always return the same instance of the attack? Is there ever an instance where it returns the most recent Attack of this type/ If not, how can we make it so it returns the last instance of this type instead of always returning the firstt? 
