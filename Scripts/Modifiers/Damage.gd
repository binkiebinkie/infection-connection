extends EvolveOption

const DAMAGE_INCREASE_PERCENTAGE = 0.05

func apply(player):
	player.damage_multiplier += DAMAGE_INCREASE_PERCENTAGE * level

func level_up():
	super.level_up()
	apply(get_tree().get_root().get_node("Game/Player"))
