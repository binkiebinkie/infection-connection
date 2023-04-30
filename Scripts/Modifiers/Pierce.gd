# Pierce.gd

extends BaseModifier

const PIERCE_INCREASE = 2

func _init():
	option_name = "Pierce"
	description = "Attack goes through multiple enemies."
	icon_path = "res://Assets/Images/Modifiers/IconPierce.png"
	
func apply(player):
	for attack in player.attacks:
		attack.pierce += PIERCE_INCREASE * level

func level_up():
	super.level_up()
	apply(get_tree().get_root().get_node("Game/Player"))
