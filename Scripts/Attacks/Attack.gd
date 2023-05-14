# res://Scripts/Attacks/Attack.gd - Manages attack instances, lone script but sometimes child of Attack instance
class_name Attack
extends EvolveOption
signal projectile_duration_reached
signal hit_enemy
const AttackTimer = preload("res://Scripts/Attacks/AttackTimer.gd")
enum ATTACK_STATES { STATE_READY, STATE_COOLDOWN }
var damage: int
var speed: float
var size: Vector2
var amount: int
var damage_type: String
var critical_chance_multiplier: float
var pierce: int
var duration: float
var cooldown: float
var cooldown_timer: float = 0
var state = ATTACK_STATES.STATE_READY
var upgrades = []
var applied_upgrades: Array = []
var attack_pool: Node2D
var player
var spawn_timer = AttackTimer.new()

func _ready():
	print('attack is ready')
	pass

func reset():
	state = ATTACK_STATES.STATE_READY
	cooldown_timer = 0

func activate(target_position, target_direction, _player, _attack_pool):
	if !player:
		player = _player
	if !attack_pool:
		attack_pool = _attack_pool
	state = ATTACK_STATES.STATE_COOLDOWN 

	spawn_timer = AttackTimer.new()
	spawn_timer.set_wait_time(cooldown)
	spawn_timer.set_one_shot(false)
	if spawn_timer.is_connected("timeout",  _on_cooldown_timer_timeout):
		spawn_timer.disconnect("timeout", _on_cooldown_timer_timeout)
	print('target_direction',target_direction)
	spawn_timer.target_position = target_position
	spawn_timer.target_direction = target_direction
	spawn_timer.player = player
	spawn_timer.connect("timeout", _on_cooldown_timer_timeout)
	attack_pool.add_child(spawn_timer)
	spawn_timer.start()

func _on_projectile_duration_reached(projectile):
	print('AHHHHHH _on_projectile_duration_reached',projectile,player,player.attacks)
	player.attacks.erase(projectile)
#	attack_pool.add_to_pool(projectile)

func _on_cooldown_timer_timeout():
	for _i in range(amount):
		_spawn_attack(spawn_timer.player, attack_pool)

func update(delta: float, character: Character, last_non_zero_input_direction, player: Node2D):
	cooldown_timer += delta
	if cooldown_timer >= cooldown:
		state = ATTACK_STATES.STATE_READY
		cooldown_timer = 0

	if state == ATTACK_STATES.STATE_READY:
		print('updateupdate STATE_READY')		
		activate(character.global_position, last_non_zero_input_direction, player, get_node("/root/Game/AttackPool"))
		state = ATTACK_STATES.STATE_COOLDOWN
		cooldown_timer = 0

func apply_upgrade(index: int):
	if index >= 0 and index < len(upgrades):
		upgrades[index].apply(self)

func level_up():
	var available_upgrades = GlobalHelpers.array_difference(upgrades, applied_upgrades)
	if not available_upgrades.empty():
		var chosen_upgrade = available_upgrades[randi() % available_upgrades.size()]
		applied_upgrades.append(chosen_upgrade)
		chosen_upgrade.apply(self)
		if applied_upgrades.size() == self.max_level:
			self.fully_evolved = true

func _spawn_attack(player, attack_pool):
	pass

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage, damage_type)
		emit_signal("hit_enemy")
		pierce -= 1
		if pierce <= 0:
			_on_projectile_duration_reached(self)

func initialize(_attack_pool, args = {}):
	if !attack_pool:
		attack_pool = _attack_pool
	if args.size() > 0:
		damage = args["damage"]
		speed = args["speed"]
		size = args["size"]
		amount = args["amount"]
		damage_type = args["damage_type"]
		critical_chance_multiplier = args["critical_chance_multiplier"]
		pierce = args["pierce"]
		duration = args["duration"]
		cooldown = args["cooldown"]

func _on_pill_area_body_entered(body):
	pass # Replace with function body.


func _on_duration_timer_timeout(projectile):
	print('AHeeeeeH _on_duration_timer_timeout',projectile)
	
	_on_projectile_duration_reached(projectile)
