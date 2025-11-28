extends Node2D

func _ready() -> void:
	$"Parallax2D/✨".play("default")
	$Player.flying = true



func _on_portal_body_entered(body: Node2D) -> void:
	Global.Speed_x = 200
	get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/vertice_7.tscn")
