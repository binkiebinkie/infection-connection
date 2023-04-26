extends Node2D

@export 
var speed: float = 600.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float):
	position += direction * speed * delta
