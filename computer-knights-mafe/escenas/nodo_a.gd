extends Node3D

@export var nombre_nodo: String = ""

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.objetivo_actual = self   # le dice al jugador "yo soy el nodo cercano"
		print("Jugador cerca de:", nombre_nodo)

func _on_body_exited(body):
	if body.is_in_group("player"):
		if body.objetivo_actual == self:
			body.objetivo_actual = null
