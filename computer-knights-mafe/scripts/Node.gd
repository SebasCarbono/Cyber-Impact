extends Node
class_name Nodo

var padre: Nodo = null
var izquierda: Nodo = null
var derecha: Nodo = null

var dato:String
var link:String

func _init(dato, link) -> void:
	self.dato = dato
	self.link = link
	self.izquierda = null
	self.derecha = null
	self.padre = null

func get_izquierda() -> Nodo:
	return izquierda

func get_derecha() -> Nodo:
	return derecha

func get_dato() -> String:
	return dato

func set_izquierda(nodo: Nodo) -> void:
	izquierda = nodo

func set_derecha(nodo: Nodo) -> void:
	derecha = nodo

func set_dato(valor: String) -> void:
	dato = valor
