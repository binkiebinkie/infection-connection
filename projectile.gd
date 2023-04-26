extends Node2D

@export var speed: float = 500.0
@export var damage: int = 10
@export var time_between_shots: float = 0.25

var direction: Vector2 = Vector2.ZERO

@onready var area = $Area2D

func _ready():
	add_to_group("projectiles")
	
func _physics_process(delta: float):
	position += direction * speed * delta

func _on_body_entered(body):
	pass

func _on_area_2d_body_entered(body):
	print("Projectile collided with: ", body.name)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
