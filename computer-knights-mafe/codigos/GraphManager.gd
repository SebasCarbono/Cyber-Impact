extends Node

var recorrido: Array = []

func agregar_nodo(nombre):
	recorrido.append(nombre)
	print("Nodo seleccionado:", nombre)
	print("Recorrido actual:", recorrido)
