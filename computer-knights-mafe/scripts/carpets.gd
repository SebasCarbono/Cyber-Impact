extends Node2D

var link = ""

func _ready():
	await get_tree().process_frame
	link = get_tree().current_scene.scene_file_path
	Global.escena_anterior = link

func _on_button_pressed() -> void:
	Global.camino_equivocado()
