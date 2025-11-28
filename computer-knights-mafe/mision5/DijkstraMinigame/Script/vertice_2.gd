extends Node2D

@onready var player = $Player
@onready var niebla = $Niebla
@export var speed_niebla = 85.0  # velocidad base de la niebla
@export var distancia_min = 200.0 # distancia donde acelera
@export var aceleracion = 25.0    # cuánto se acelera cuando está lejos

func _ready():
	$"Parallax2D/✨".play("default")
	player.flying = true

func _process(delta):
	if not player or not niebla:
		return
	
	# solo calculamos la dirección horizontal
	var direccion_x = sign(player.position.x - niebla.position.x)
	var distancia_x = abs(player.position.x - niebla.position.x)
	
	# si está muy lejos, acelera un poco
	var velocidad_actual = speed_niebla + (aceleracion if distancia_x > distancia_min else 0)
	
	# mueve solo en el eje X
	niebla.position.x += direccion_x * velocidad_actual * delta
	
	# efecto glitch pequeño (solo horizontal)
	var shake_x = randf_range(-1.5, 1.5)
	niebla.position.x += shake_x

func _on_portal_body_entered(body: CharacterBody2D) -> void:
	Global.Speed_x = 200
	get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/vertice_3.tscn")

func _on_abajo_body_entered(body: CharacterBody2D) -> void:
	Global.Speed_x = 200
	get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/vertice_4.tscn")


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	print("Game over")
