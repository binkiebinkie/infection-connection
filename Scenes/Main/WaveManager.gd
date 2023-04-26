extends Node2D

@onready var player = get_node("/root/Game/Player")
@export var wave_duration: float = 5.0
@export var enemy_scene = preload("res://Scenes/Enemies/base_enemy.tscn")
var current_wave: int = 0
var enemies_in_wave: int = 50
var wave_timer: float = 0.0

func _ready():
	start_wave()

func start_wave():
	current_wave += 1
	enemies_in_wave = 5 * current_wave
	wave_timer = wave_duration
	spawn_enemies()

func _process(delta):
	wave_timer -= delta
	if wave_timer <= 0:
		start_wave()

func spawn_enemies():
	for i in range(enemies_in_wave):
		var enemy = enemy_scene.instantiate()
		enemy.position = get_spawn_position()
		get_parent().add_child.call_deferred(enemy)

func get_spawn_position():
	var viewport = get_viewport().size
	var spawn_margin: int = 100

	var player_pos = player.global_position
	var spawn_x: float = 0.0
	var spawn_y: float = 0.0

	if randi() % 2 == 0:  # Randomly choose between spawning on horizontal or vertical axis
		# Horizontal spawn
		spawn_x = player_pos.x + (randf_range(0, 2) * 2 - 1) * (viewport.x / 2 + spawn_margin)
		spawn_y = player_pos.y + (randf() * 2 - 1) * viewport.y / 2
	else:
		# Vertical spawn
		spawn_x = player_pos.x + (randf() * 2 - 1) * viewport.x / 2
		spawn_y = player_pos.y + (randf_range(0, 2) * 2 - 1) * (viewport.y / 2 + spawn_margin)

	if abs(spawn_x - player_pos.x) < viewport.x / 2:
		spawn_x += sign(spawn_x - player_pos.x) * viewport.x / 2

	if abs(spawn_y - player_pos.y) < viewport.y / 2:
		spawn_y += sign(spawn_y - player_pos.y) * viewport.y / 2

	return Vector2(spawn_x, spawn_y)
