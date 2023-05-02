class_name Player
extends Node2D

@onready var virtual_joystick: Node = get_node("/root/Game/VirtualJoystick")
@onready var health_label = get_node("/root/Game/Player/Camera2D/HealthLabel")
@onready var dna_label = get_node("/root/Game/UICamera/UI/DNALabel")
@onready var evolve_options = []
@onready var attack_pool = AttackPool.new()
@onready var evolution_manager = EvolutionManager.new(attack_pool)
@onready var evolution_drawer = EvolutionDrawer.new(evolution_manager)
const EvolutionManager = preload("res://Scripts/Main/EvolutionManager.gd")
var last_shot_time: float = 0.0
var dna: int = 0
var dna_to_evolve: int = 10
var queued_evolutions_count: int = 1
var queued_evolutions = []
var attacks = []
var last_non_zero_input_direction: Vector2 = Vector2(1,0)
var character = await Global.selected_character.new(attack_pool)  # pass the attack_pool instance

signal player_evolved(queued_evolutions_count)

func _ready():
	var map_node = get_node("../Background")
	var map_width = map_node.texture.get_width()
	var map_height = map_node.texture.get_height()
	var map_size = Vector2(map_width, map_height)
	position = map_size / 2
	character.initialize(self)
	print('character',character)
	print('character',character.starting_attack)
	character.add_attack(character.starting_attack, attack_pool)
	character.starting_attack.connect("projectile_duration_reached", _on_projectile_duration_reached)
	print('character.starting_attack',character.starting_attack)
	attack_pool.add_to_pool(character.starting_attack)	
	add_child(character)
	
func _physics_process(delta: float):
	var input_direction = -virtual_joystick.get_input_direction()

	if input_direction != Vector2.ZERO:
		character.set_last_non_zero_input_direction(input_direction)
		var angle = atan2(input_direction.y, input_direction.x)
		self.rotation = angle
		position += input_direction * character.speed * delta
		
		var map_node = get_node("../Background")
		var map_width = map_node.texture.get_width()
		var map_height = map_node.texture.get_height()
		position.x = clamp(position.x, 0, map_width)
		position.y = clamp(position.y, 0, map_height)

	for attack in character.attacks:
		if is_instance_valid(attack):
			attack.update(delta, character, character.last_non_zero_input_direction)

func _on_projectile_duration_reached(projectile):
	character.attacks.erase(projectile)
	attack_pool.add_to_pool(projectile)

func take_damage(damage: int):
	character.health -= damage
	health_label.text = "Health: %s" % character.health

	if character.health <= 0:
		health_label.text = "Game Over"

func collect_dna(dna_value):
	dna += dna_value
	dna_label.text = "DNA: %s" % dna
	if dna >= dna_to_evolve:
		evolve()
		dna -= dna_to_evolve

func evolve():
	queued_evolutions_count += 1
	queued_evolutions = evolution_manager.get_random_options(3)
	character.level += 1
	character.health += 10
	character.speed += 10
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
		option.apply(character)
		evolve_options.append(option)
	queued_evolutions_count -= 1	

func get_queued_evolutions_count() -> int:
	return queued_evolutions_count
