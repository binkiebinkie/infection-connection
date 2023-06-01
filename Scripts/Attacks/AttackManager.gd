# AttackManager.gd - Node where attacks can spawn from. Also manages creating, removing and active attacks
extends Node2D
# This array is used to track the attacks that are currently active in the game world. 
# When an attack is spawned, it is added to this array. When it ends (e.g. it hits a target or its duration ends), it is removed.
var active_attacks = []

func spawn_attack(attack_instance):
	self.add_child(attack_instance)
	active_attacks.append(attack_instance)

func remove_attack(attack_instance):
	active_attacks.erase(attack_instance)
