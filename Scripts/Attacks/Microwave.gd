extends Attack

const NUM_RAYS = 2
class MicrowaveUpgrade:
	var apply
	func _init(_apply):
		apply = _apply
		
func _init(_damage: int, _speed: float, _size: Vector2, _amount: int, _damage_type: String, _critical_chance_multiplier: float, _pierce: int, _duration: int, _cooldown: int, _attack_pool):
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
	option_name = "Microwave"
	description = "Zap your enemies with many rays"
	icon_path = "res://Assets/Images/Attacks/microwave.png"
	
	upgrades = [
		MicrowaveUpgrade.new(func(attack): attack.amount += 2),
		MicrowaveUpgrade.new(func(attack): attack.amount += 2),
		MicrowaveUpgrade.new(func(attack): attack.pierce += 3),
		MicrowaveUpgrade.new(func(attack): attack.damage *= 1.25),
		MicrowaveUpgrade.new(func(attack): attack.duration *= 1.5),
		MicrowaveUpgrade.new(func(attack): attack.speed *= 1.3),
		MicrowaveUpgrade.new(func(attack): attack.cooldown *= 0.7)
	]

func activate(target_position, target_direction):
	super.activate(target_position, target_direction)
	for i in range(NUM_RAYS):
		var random_angle = randf_range(-PI, PI)
		var random_direction = Vector2(cos(random_angle), sin(random_angle))
		_spawn_attack(target_position, random_direction)

#func activate(target_position, target_direction):
#	super.activate(target_position, target_direction)
#	_spawn_attack(target_position, target_direction)

func spawn_ray(position, direction):
	var microwave_ray_scene = load("res://Scenes/Attacks/MicrowaveRay.tscn")
	var ray = microwave_ray_scene.instantiate()

	var range = duration * speed # Calculate the range
	ray.cast_to = direction * range
	ray.enabled = true
	ray.add_exception(get_tree().get_root().get_node("Game/Player"))
	ray.set_collision_mask(2) # Enemies

	get_parent().add_child(ray)
	ray.global_position = position
	ray.connect("body_entered", self, "_on_ray_body_entered", [ray, pierce])

	# Set the sprite scale
	ray.get_node("Sprite").scale.x = range

func _on_ray_body_entered(ray, remaining_pierce, body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	remaining_pierce -= 1
	if remaining_pierce <= 0:
		ray.queue_free()
