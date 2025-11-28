extends Node2D

@onready var transformacion = $CanvasLayer2/VideoStreamPlayer
@onready var canvas_layer = $CanvasLayer2

func _ready():
	
	
	$"Parallax2D/✨".play("default")
	await _mostrar_dialogo([
		"¡Huyó!",
		"Debemos alcanzarlo antes de que corrompa más sistemas.",
		"Para eso… tendremos que recurrir a uno de nuestros miembros aéreos.",
		"Guía a Cyber hasta el nodo infectado y restaura la red en el menor tiempo posible.",
		"Confiamos en ti… no nos falles.",
		"¡CYBER, YO TE ELIJO!"
	])
	
	get_tree().paused = true
	transformacion.play()
	await transformacion.finished
	canvas_layer.hide()
	get_tree().paused = false 
	$CanvasLayer/ColorRect.visible = false
	$Player.flying = true
	
func _mostrar_dialogo(textos: Array) -> void:
	var balloon_scene = load("res://mision5/Kruskal/Scenes/example_balloon.tscn").instantiate()
	add_child(balloon_scene)
	balloon_scene.show_messages(textos)

	# Esperar hasta que balloon.visible sea false (cuando ya no hay más mensajes)
	while balloon_scene.balloon.visible:
		await get_tree().process_frame

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	Global.Speed_x = 200
	get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/vertice_2.tscn")
func _on_area_2d_2_body_entered(body: CharacterBody2D) -> void:
	Global.Speed_x = 200
	get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/vertice_4.tscn")
func _on_area_2d_3_body_entered(body: CharacterBody2D) -> void:
	Global.Speed_x = 200
	get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/vertice_5.tscn")
