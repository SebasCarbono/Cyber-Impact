# Kruskal.gd
extends RefCounted
class_name Kruskal

var V: int
var edges: Array = []  # [origen, destino, peso]
var edges_WP : Array = []
func _init(p_v: int):
	V = p_v
	edges = []
	edges_WP = []

func add_edge(src: int, dest: int, weight: int):
	edges.append([src, dest, weight])
	
func add_edge_WP(src: int, dest: int):
	edges_WP.append([src, dest])

# --- Union-Find ---
func find(parent: Array, i: int) -> int:
	if parent[i] == -1:
		return i
	parent[i] = find(parent, parent[i])
	return parent[i]

func union(parent: Array, x: int, y: int):
	var xset = find(parent, x)
	var yset = find(parent, y)
	if xset != yset:
		parent[xset] = yset

# --- MST ---
func kruskal_mst_edges() -> Array:
	var result: Array = []
	var parent: Array = []
	parent.resize(V)
	for i in range(V):
		parent[i] = -1

	# Ordenar aristas por peso
	edges.sort_custom(func(a, b):
		return a[2] < b[2]
	)

	var edge_count = 0
	for e in edges:
		if edge_count >= V - 1:
			break
		var x = find(parent, e[0])
		var y = find(parent, e[1])
		if x != y:
			result.append(e)
			union(parent, x, y)
			edge_count += 1
	print(result)
	return result
	
func get_edges_without_weight() -> Array:
	var result: Array = []
	for e in kruskal_mst_edges():
		result.append([e[0], e[1]])
	return result

func kruskal_mst() -> int:
	var mst_edges = kruskal_mst_edges()
	var sum = 0
	for e in mst_edges:
		sum += e[2]
	return sum
