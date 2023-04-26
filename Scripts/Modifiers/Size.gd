# Size.gd

extends BaseModifier

const SIZE_INCREASE_PERCENTAGE = 0.25 # 25%

func _init():
	name = "Size Increase"
	description = "Increases the size of your attacks."

func apply(player):
	for attack in player.attacks:
		attack.size += attack.size * SIZE_INCREASE_PERCENTAGE * level

func level_up():
	super.level_up()
	apply(get_tree().get_root().get_node("Game/Player"))
