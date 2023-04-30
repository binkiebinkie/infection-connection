# Cooldown.gd

extends BaseModifier
const COOLDOWN_REDUCTION_PERCENTAGE = 0.25

func _init():
	option_name = "Cooldown Reduction"
	description = "Reduces the cooldown between attacks."
	icon_path = "res://Assets/Images/Modifiers/IconCooldown.png"

func apply(player):
	for attack in player.attacks:
		attack.duration = max(attack.duration * pow(1 - COOLDOWN_REDUCTION_PERCENTAGE, level), 0.1)

func level_up():
	super.level_up()
	apply(get_tree().get_root().get_node("Game/Player"))
