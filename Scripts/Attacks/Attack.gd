# res://Scripts/Attacks/Attack.gd - Manages attack instances, lone script but sometimes child of Attack instance
class_name Attack
extends EvolveOption
const AttackTimer = preload("res://Scripts/Attacks/AttackTimer.gd")
signal projectile_duration_reached
signal hit_enemy
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
var player
var spawn_timer = AttackTimer.new()

func _ready():
	pass

func reset():
	state = ATTACK_STATES.STATE_READY
	cooldown_timer = 0

func activate(_player):
	if !player:
		player = _player
	state = ATTACK_STATES.STATE_COOLDOWN 
	var _cooldown_timer = Timer.new()
	_cooldown_timer.set_wait_time(cooldown)
	_cooldown_timer.set_one_shot(false)
	_cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)	
	_cooldown_timer.set_autostart(true)
	AttackManager.add_child(_cooldown_timer)

func _on_cooldown_timer_timeout():
	for _i in range(amount):
		_spawn_attack()

func update(delta: float, character: Character, player: Node2D):
	cooldown_timer += delta
	if cooldown_timer >= cooldown:
		state = ATTACK_STATES.STATE_READY
		cooldown_timer = 0

	if state == ATTACK_STATES.STATE_READY:
		activate(player)
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

func _spawn_attack():
	pass

func initialize(args = {}):
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

func duplicate_attack(args = {}) -> Attack:
	var new_attack = self.duplicate()
	new_attack.initialize(args)
	return new_attack
