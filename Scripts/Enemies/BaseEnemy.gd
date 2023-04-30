extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")
@onready var health_label = get_node("HealthLabel")
@onready var dna_scene = load("res://Scenes/Enemies/dna.tscn")
@export var health: int = 25
@export var speed: float = 100.0
@export var size: Vector2 = Vector2(1, 1)
@export var damage: int = 10
@export var movement_pattern: int = 0
@export var duration: int = 1
var invincibility_timer: float = 0.0
var invincibility_duration: float = 0.3

func _ready():
	scale = size

func _physics_process(delta):
	match movement_pattern:
		0:
			default_movement_pattern(delta)
	invincibility_timer = max(0, invincibility_timer - delta)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("I collided with ", collision.get_collider().name)

func _on_area_2d_area_entered(area):
	if area == player.get_node("Area2D") and invincibility_timer == 0:
		player.take_damage(damage)
		invincibility_timer = invincibility_duration
	elif area.is_in_group("projectiles"):
		take_damage(area.attack_data.damage, area.attack_data.damage_type)
		area.queue_free()

func default_movement_pattern(delta):
	var direction = (player.position - position).normalized()
	position += direction * speed * delta

func take_damage(damage_amount, damage_type):
	health -= damage_amount
	update_health_label() 
	if health <= 0:
		die()

func die():
	var dna = dna_scene.instantiate()
	dna.position = self.position
	get_parent().add_child.call_deferred(dna)
	queue_free()
	
func update_health_label():
	health_label.text = str(health)
