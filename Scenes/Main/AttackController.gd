extends Node
#
## Add a variable to store the attack scene and the player reference
##@export PackedScene
#@onready var player = get_node("..") # Assuming AttackController is a direct child of the player
#var attack_scene: PackedScene
#
## Add a timer for the attack cooldown
#@onready var attack_timer = Timer.new()
#
#func _ready():
#	add_child(attack_timer)
#	attack_timer.set_wait_time(5) # Set attack cooldown duration
#	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
#	attack_timer.start()
#
#func _on_attack_timer_timeout():
#	if attack_scene == null:
#		return
#
#	var attack = attack_scene.instantiate()
#	attack.position = player.position
#	get_parent().add_child(attack)
