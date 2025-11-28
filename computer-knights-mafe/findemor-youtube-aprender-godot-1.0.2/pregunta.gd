extends Node2D



func _on_b_pressed() -> void:
	Global.escena = null
	queue_free()


func _on_a_pressed() -> void:
	Global.escena = null
	get_tree().change_scene_to_file("res://findemor-youtube-aprender-godot-1.0.2/niveles/level_1.tscn")



func _on_c_pressed() -> void:
	Global.escena = null
	get_tree().change_scene_to_file("res://findemor-youtube-aprender-godot-1.0.2/niveles/level_1.tscn")



func _on_d_pressed() -> void:
	Global.escena = null
	get_tree().change_scene_to_file("res://findemor-youtube-aprender-godot-1.0.2/niveles/level_1.tscn")
