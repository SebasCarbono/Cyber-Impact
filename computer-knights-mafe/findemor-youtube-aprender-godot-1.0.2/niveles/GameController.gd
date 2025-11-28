extends Node2D

const SCENE_FINISH_FILE = "res://Scenes/seleccion.tscn"
signal player_health_updated(new_player_health)
signal time_updated(seconds_left)

@export var player_health = 3
@export var time_seconds = 100
var link = ""

func _ready():
	await get_tree().process_frame
	link = get_tree().current_scene.scene_file_path
	Global.escena_anterior = link

func _process(delta: float) -> void:
	if Global.escena != null:
		$"../CanvasLayer".add_child(Global.escena)

func game_over():
	get_tree().change_scene_to_file(SCENE_FINISH_FILE)
	

func _on_area_2d_body_entered(body:CharacterBody2D):
	get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/control.tscn")

func _on_timer_timeout():
	if time_seconds > 0:
		time_seconds = time_seconds - 1
	if time_seconds <= 0:
		game_over()
	time_updated.emit(time_seconds)
