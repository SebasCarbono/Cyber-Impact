class_name Barril
extends RigidBody2D

@export var demasiado_abajo: float = 1000.0
@export var velocidad_caida: float = 1500.0 
var escena
var questions = [
	preload("res://findemor-youtube-aprender-godot-1.0.2/pregunta.tscn"),
	preload("res://findemor-youtube-aprender-godot-1.0.2/ASK4.tscn"),
	preload("res://findemor-youtube-aprender-godot-1.0.2/ASK3.tscn"),
	preload("res://findemor-youtube-aprender-godot-1.0.2/ask2.tscn")
]

func _ready():
	linear_velocity = Vector2(0, velocidad_caida)

func _process(delta: float) -> void:
	if position.y > demasiado_abajo:
		queue_free()

func _on_body_entered(body:CharacterBody2D) -> void:
	var index := randi() % questions.size()
	escena = questions[index].instantiate()
	Global.escena = escena
	queue_free()
	
