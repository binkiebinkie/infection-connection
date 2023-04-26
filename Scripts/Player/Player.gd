extends Sprite2D

@onready var virtual_joystick: Node = get_node("/root/Game/VirtualJoystick")
@onready var projectile_scene = load("Scenes/Projectiles/projectile.tscn")
@onready var health_label = get_node("/root/Game/Player/Camera2D/HealthLabel")
@onready var dna_label = get_node("/root/Game/UICamera/UI/DNALabel")
@onready var evolve_options = []
@onready var evolution_manager = EvolutionManager.new()
@export var speed: float = 1000.0
@export var projectile_speed_multiplier: float = 3.0
@export var time_between_shots: float = 0.25
const EvolutionManager = preload("res://Scripts/Main/EvolutionManager.gd")
var last_shot_time: float = 0.0
var health: int = 100
var level: int = 1
var dna: int = 0
var dna_to_evolve: int = 10
var queued_evolutions_count: int = 0

signal player_evolved(queued_evolutions_count)


func _ready():
	var map_node = get_node("../Background")
	var map_width = map_node.texture.get_width()
	var map_height = map_node.texture.get_height()
	var map_size = Vector2(map_width, map_height)
	position = map_size / 2	

func _physics_process(delta: float):
	var input_direction = -virtual_joystick.get_input_direction()
	if input_direction != Vector2.ZERO:
		var angle = atan2(input_direction.y, input_direction.x)
		self.rotation = angle
		position += input_direction * speed * delta
		
		# Get the background node and its size
		var map_node = get_node("../Background")
		var map_width = map_node.texture.get_width()
		var map_height = map_node.texture.get_height()
		
		# Clamp the position within the background sprite bounds
		position.x = clamp(position.x, 0, map_width)
		position.y = clamp(position.y, 0, map_height)
	
	# Shoot a projectile
	last_shot_time += delta
	if last_shot_time >= get_projectile_time_between_shots():
		last_shot_time = 0.0
		var direction = Vector2(cos(rotation), sin(rotation))
		shoot_projectile(direction)

func shoot_projectile(direction: Vector2):
	var projectile = projectile_scene.instantiate()
	projectile.direction = direction
	projectile.speed = speed * projectile_speed_multiplier
	projectile.position = self.position
	projectile.rotation = self.rotation
	get_parent().add_child(projectile)

func take_damage(damage: int):
	health -= damage
	health_label.text = "Health: %s" % health

	if health <= 0:
		# Handle player death, e.g., display game over screen or respawn the player
		health_label.text = "Game Over"

func collect_dna(dna_value):
	dna += dna_value
	dna_label.text = "DNA: %s" % dna
	# Check if the player has enough DNA to evolve
	if dna >= dna_to_evolve:
		evolve()
		dna -= dna_to_evolve

func evolve():
	queued_evolutions_count += 1
	
	var available_options = evolution_manager.get_random_options(3)
	var choices = []
	for _i in range(3):
		var choice = available_options[randi() % available_options.size()]
		choices.append(choice)
		available_options.erase(choice)
	
	level += 1
	health += 10
	speed += 10
	dna_to_evolve += 10
	emit_signal("player_evolved", queued_evolutions_count)
	
func apply_evolve_option(option: EvolveOption):
	var existing_option = null
	for evolve_option in evolve_options:
		if evolve_option.get_script() == option.get_script():
			existing_option = evolve_option
			break
	if existing_option:
		existing_option.level_up()
	else:
		option.apply(self)
		evolve_options.append(option)
	queued_evolutions_count -= 1	

func get_projectile_time_between_shots():
	var projectile_instance = projectile_scene.instantiate()
	var time_between_shots = projectile_instance.time_between_shots
	projectile_instance.queue_free()
	return time_between_shots
	
func get_queued_evolutions_count() -> int:
	return queued_evolutions_count
