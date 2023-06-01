# res://Scenes/Attacks/Pill.tscn - Pill.gd, Attack instance 
# Pill child nodes: Sprite2D, DurationTimer, PillArea -> CollisionShape2D
extends Attack
signal is_ready
#@onready var attack_spawn = get_node("/root/Game/AttackManager")
const PillAreaScript = preload("res://Scripts/Attacks/PillArea.gd")
const DAMAGE_INCREASE = 0.25
const SPEED_INCREASE = 1.0
const COOLDOWN_REDUCTION = 0.25
const attack_type = "Pill"
var attack_data: Attack = null
var linear_velocity
var direction: Vector2 = Vector2.ZERO
var duration_timer: Timer

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

	option_name = "Pill"
	description = "Throws a pill projectile to damage enemies."
	icon_path = "res://Assets/Images/Attack/pill.png"

func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	position += direction * speed * delta

func _spawn_attack():
	var new_attack = self.duplicate_attack({
		"damage": damage,
		"speed": speed,
		"size": size,
		"amount": amount,
		"damage_type": damage_type,
		"critical_chance_multiplier": critical_chance_multiplier,
		"pierce": pierce,
		"duration": duration,
		"cooldown": cooldown
	})
	var angle_range = PI / 18
	var random_angle = randf_range(-angle_range, angle_range)
	new_attack.direction = GlobalPlayer.direction.rotated(random_angle)
	new_attack.linear_velocity = new_attack.direction.normalized() * new_attack.speed
	new_attack.position = GlobalPlayer.position
	
	var pill_area = new_attack.get_node("PillArea")
	pill_area.initialize(new_attack, new_attack.direction)
	
	duration_timer = Timer.new()
	duration_timer.set_wait_time(new_attack.duration)
	duration_timer.one_shot = true
	duration_timer.timeout.connect(new_attack._on_duration_timer_timeout)	
	duration_timer.autostart = true	
	
	new_attack.add_child(duration_timer)
	AttackManager.add_child(new_attack)
	
func _on_duration_timer_timeout():
	AttackManager.remove_attack(self)  # remove self from active attacks
	queue_free()

func _on_pill_area_body_entered(body):
	print('body',body)
	if body.has_method("take_damage"):
		body.take_damage(damage, damage_type)
		emit_signal("hit_enemy")
		pierce -= 1
		if pierce <= 0:
			_on_duration_timer_timeout()
