extends Area2D

signal duration_reached
var direction: Vector2 = Vector2()
var attack_data: Attack = null

#func _ready():
#	connect("body_entered", Callable(attack_data, "_on_body_entered"))

func initialize(attack_data, direction):
	self.attack_data = attack_data
	self.direction = direction
	connect("body_entered", Callable(attack_data, "_on_body_entered"))
	
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(attack_data.damage, attack_data.damage_type)
		attack_data.pierce -= 1
		if attack_data.pierce <= 0:
			attack_data.emit_signal("projectile_duration_reached", attack_data)
#
#func initialize(new_direction: Vector2, new_attack_data: Attack) -> void:
#	direction = new_direction
#	attack_data = new_attack_data
#func initialize(args: Array) -> void:
#	direction = args[0]
#	attack_data = args[1]
#
#func _physics_process(delta: float):
#	if attack_data:
#		position += direction * attack_data.speed * delta
#
#func _on_duration_timer_timeout():
#	emit_signal("duration_reached")
#	queue_free()
