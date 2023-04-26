class_name UpgradeableAttack
extends BaseAttack

var upgrades: Array
var applied_upgrades: Array = []

func level_up():
	var available_upgrades = GlobalHelpers.array_difference(upgrades, applied_upgrades)
	
	if not available_upgrades.empty():
		var chosen_upgrade = available_upgrades[randi() % available_upgrades.size()]
		applied_upgrades.append(chosen_upgrade)
		chosen_upgrade.apply(self)
		
		if applied_upgrades.size() == self.max_level:
			self.fully_evolved = true

