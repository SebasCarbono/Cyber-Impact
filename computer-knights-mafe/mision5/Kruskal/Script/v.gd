extends Area2D

@export var id_nodo: int = 0 # Identificador numérico
@export var color_seleccion: Color = Color(0.2, 0.6, 1, 1) # Color al seleccionar

var seleccionada: bool = false
@onready var sprite = $Red
