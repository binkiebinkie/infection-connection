extends Node

func array_difference(a1: Array, a2: Array) -> Array:
	var diff = []
	for item in a1:
		if not a2.has(item):
			diff.append(item)
	return diff
