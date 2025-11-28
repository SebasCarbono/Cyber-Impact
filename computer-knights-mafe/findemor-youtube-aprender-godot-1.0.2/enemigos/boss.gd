class_name Boss
extends Node2D

@onready var animation_player = $AnimationPlayer
const ESCENA_BARRIL = preload("res://findemor-youtube-aprender-godot-1.0.2/enemigos/barril.tscn")

func _ready():
	$CharacterSquareRed.play("idle")
	$Timer.connect("timeout", _on_timer_timeout)
	$Timer.start()  

func _process(delta: float) -> void:
	if Global.termino:
		$CharacterSquareRed.play("dead")
		await get_tree().create_timer(1.0).timeout
		$CharacterSquareRed.play("muerto")
		await get_tree().create_timer(2.0).timeout
		Global.camino_equivocado()
func launch_barrel():
	if Global.termino:
		return 
	var instancia_barril = ESCENA_BARRIL.instantiate()
	instancia_barril.position = $CharacterSquareRed.position
	add_child(instancia_barril)
	$CharacterSquareRed.play("attack")


func _on_timer_timeout():
	launch_barrel() 
	$Timer.wait_time = randf_range(2, 3)
	$Timer.start()

func _on_character_square_red_animation_finished() -> void:
	$CharacterSquareRed.play("idle")
