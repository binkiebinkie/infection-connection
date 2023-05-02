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
	print('sdfsaddasssadf')
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
	duration_timer = get_node("DurationTimer")
	print('dduration_timer',duration_timer)

func _ready():
	print('attaceawwcwc')
	pass

func _on_projectile_duration_timeout():
	print('timed out')
	emit_signal("projectile_duration_reached", self)
	
func reset():
	state = ATTACK_STATES.STATE_READY
	cooldown_timer = 0
	if duration_timer:
		duration_timer.stop()

func activate(target_position, target_direction):
	print('amount', amount)
	for _i in range(amount):
		print('_i',_i)
		_spawn_attack(target_position, target_direction)
		print('duration', duration)
		var timeout_timer = Timer.new()
		timeout_timer.wait_time = duration
		timeout_timer.one_shot = true
		timeout_timer.connect("timeout", _on_projectile_duration_timeout)
		timeout_timer.autostart = true
		add_child(timeout_timer)
	
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
	pass
#	var attack_instance = attack_pool.get_from_pool('Attack', [target_position, target_direction])
#	attack_instance.connect("projectile_duration_reached", _on_projectile_duration_timeout)

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage, damage_type)
		emit_signal("hit_enemy")
		pierce -= 1
		if pierce <= 0:
			emit_signal("projectile_duration_reached", self)

func initialize(_damage: int, _speed: float, _size: Vector2, _amount: int, _damage_type: String, _critical_chance_multiplier: float, _pierce: int, _duration: float, _cooldown: float, _attack_pool):
	print('ahsfasasffa')
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

func _on_pill_area_body_entered(body):
	pass # Replace with function body.
