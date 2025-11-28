extends Control

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	



func _on_button_pressed() -> void:
	VGlobal.desicion = "BFS"
	get_tree().change_scene_to_file("res://mision5/Scenes/main.tscn")
	


func _on_button_2_pressed() -> void:
	VGlobal.desicion = "DFS"
	get_tree().change_scene_to_file("res://mision5/Scenes/main.tscn")
