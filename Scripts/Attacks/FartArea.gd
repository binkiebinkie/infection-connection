extends Area2D

var damage: int
var speed: float
var direction: Vector2
var duration: int

@onready var timer: Timer = $Timer

func _ready():
	timer.start(duration)
	timer.timeout.connect(on_timer_timeout)

func _physics_process(delta):
	position += direction * speed * delta

func _on_Timer_timeout():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
