extends Node

func generate_combination(length: int) -> Array:
	var combination = []
	for i in range(length):
		combination.append(randi() % 10)
	return combination
