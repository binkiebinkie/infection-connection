# Pierce.gd

extends BaseModifier

const PIERCE_INCREASE = 2

func _init():
	name = "Piercing Increase"
	description = "Increases the number of enemies that projectiles can pierce."

func apply(player):
	for attack in player.attacks:
		attack.pierce += PIERCE_INCREASE * level

func level_up():
	super.level_up()
	apply(get_tree().get_root().get_node("Game/Player"))
