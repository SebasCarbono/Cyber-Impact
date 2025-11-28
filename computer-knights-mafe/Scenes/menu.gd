extends Node2D

@onready var jugar_button = $Button
@onready var tutorial_button = $Button2
@onready var salir_button = $Button3
#@onready var transformacion = $CanvasLayer/VideoStreamPlayer
#@onready var canvas_layer = $CanvasLayer
func _ready():
	#get_tree().paused = true
	#transformacion.play()
	#await transformacion.finished
	#canvas_layer.hide()
	#get_tree().paused = false
	$Button.pressed.connect(_on_play_pressed)
	$Button2.pressed.connect(_on_tutorial_pressed)
	$Button3.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://intro/scenes/intro.tscn")

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")

func _on_quit_pressed():
	get_tree().quit()
