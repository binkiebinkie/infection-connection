class_name Attack
extends EvolveOption
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
var duration_timer: Timer
var attack_pool

func _init(_damage: int, _speed: float, _size: Vector2, _amount: int, _damage_type: String, _critical_chance_multiplier: float, _pierce: int, _duration: float, _cooldown: float, _attack_pool):
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

func _ready():
	duration_timer = get_node("DurationTimer")

func _on_projectile_duration_timeout():
	print('timed out')
	emit_signal("projectile_duration_reached", self)
	
func reset():
	state = ATTACK_STATES.STATE_READY
	cooldown_timer = 0
	duration_timer.stop()

func activate(target_position, target_direction):
	for _i in range(amount):
		_spawn_attack(target_position, target_direction)
		print('activate attack')
		_spawn_attack(target_position, target_direction)
		print('duration', duration)
		print('tree exists')
		var timeout_timer = Timer.new()
		timeout_timer.set_wait_time(duration)
		timeout_timer.set_one_shot(true)
		timeout_timer.connect("timeout", Callable(self, "_on_projectile_duration_timeout"))
		add_child(timeout_timer)
		timeout_timer.start()
	
func update(delta: float, character: Character, last_non_zero_input_direction: Vector2):
	if state == ATTACK_STATES.STATE_COOLDOWN:
		cooldown_timer += delta
		if cooldown_timer >= cooldown:
			state = ATTACK_STATES.STATE_READY
			cooldown_timer = 0
	
	if state == ATTACK_STATES.STATE_READY:
		activate(character.global_position, last_non_zero_input_direction)
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

func _spawn_attack(target_position, target_direction):
	var attack_instance = attack_pool.get_from_pool(Attack, [target_position, target_direction])
	attack_instance.connect("projectile_duration_reached", _on_projectile_duration_timeout)

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage, damage_type)
		emit_signal("hit_enemy")
		pierce -= 1
		if pierce <= 0:
			emit_signal("projectile_duration_reached", self)
