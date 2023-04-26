extends Node2D

const PICKUP_RADIUS = 300.0
const PICKUP_SPEED = 2000.0
const DNA_VALUE = 1

@onready var player = get_node("/root/Game/Player")

func _physics_process(delta):
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player <= PICKUP_RADIUS:
		var direction_to_player = (player.global_position - global_position).normalized()
		global_position += direction_to_player * PICKUP_SPEED * delta
		if distance_to_player < 10:
			player.collect_dna(DNA_VALUE)
			queue_free()
