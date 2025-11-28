extends Area2D

@export var nombre = ""
@export var paso = false
@onready var sprite = $Sprite2D
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player") and !paso:
		$Sprite2D.texture = preload("res://mision5/Node.png")
		paso = true
		$"../..".save(nombre)
		print(nombre)
