extends BaseAttack

const NUM_RAYS = 10

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

func activate(target_position, target_direction):
	for i in range(NUM_RAYS):
		var random_angle = randf_range(-PI, PI)
		var random_direction = Vector2(cos(random_angle), sin(random_angle))
		spawn_ray(target_position, random_direction)

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
