extends Node
class_name Vertices
var dato: String
var nodo_sprite: Node2D
var adyacentes: Array = []
var id: int
static var cid := 0

func _init(_dato: String) -> void:
	dato = _dato
	id = cid
	cid += 1

func agregar_adyacente(v: Vertices) -> void:
	adyacentes.append(v)

func get_adyacentes() -> Array:
	return adyacentes

func _to_string() -> String:
	var ady_str = ""
	for a in adyacentes:
		ady_str += a.dato + ", "
	if ady_str.length() > 0:
		ady_str = ady_str.substr(0, ady_str.length() - 2)
	return "Vertice{nombre='" + dato + "', adyacentes=" + ady_str + "}"
