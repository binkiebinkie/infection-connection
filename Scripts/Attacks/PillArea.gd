extends Area2D

var direction: Vector2 = Vector2()
var attack_data: Attack = null

func _ready():
	attack_data.connect("projectile_duration_reached", _on_projectile_duration_reached)
	connect("body_entered", Callable(attack_data, "_on_body_entered"))

func _physics_process(delta: float):
	if attack_data:
		position += direction * attack_data.speed * delta

func _on_projectile_duration_reached(attack_instance):
	print('pillarea _on_projectile_duration_reached')
	if attack_instance == attack_data:
		queue_free()
