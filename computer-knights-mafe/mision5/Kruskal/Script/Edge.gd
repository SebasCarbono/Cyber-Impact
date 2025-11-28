extends Node

class Edge:
	var src: int
	var dest: int
	var weight: int

	func _init(p_src: int, p_dest: int, p_weight: int):
		src = p_src
		dest = p_dest
		weight = p_weight

	# Permite ordenar las aristas por peso
	func _lt(other: Edge) -> bool:
		return weight < other.weight
