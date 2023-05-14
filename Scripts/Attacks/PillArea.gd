# res://Scripts/Attacks/PillArea.gd - child Area2D of Pill Node2D
extends Area2D

signal duration_reached
var direction: Vector2 = Vector2()
var attack_data: Attack = null

func initialize(_attack_data, _direction):
	print("PillArea initialize - attack_data:", _attack_data, "direction:", _direction)
	self.attack_data = _attack_data
	self.direction = _direction
	attack_data.speed = _attack_data.speed
#	connect("body_entered",  _on_body_entered)

#func _on_body_entered(body):
#	print('enteded body - pillarea',body)
#	if body.has_method("take_damage"):
#		body.take_damage(attack_data.damage, attack_data.damage_type)
#		attack_data.pierce -= 1
#		if attack_data.pierce <= 0:
#			attack_data.emit_signal("projectile_duration_reached", attack_data)
