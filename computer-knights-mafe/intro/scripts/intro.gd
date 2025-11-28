extends Node2D

@onready var nemi: Node2D = $Nemi
@onready var transformacion = $CanvasLayer/VideoStreamPlayer
@onready var canvas_layer = $CanvasLayer
@onready var timer_15 = $Timer15     # El Timer que sonará al segundo 15
@onready var audio_extra =  $AudioStreamPlayer2# El nuevo audio a reproducir

func _ready() -> void:
	get_tree().paused = true
	transformacion.play()
	$AudioStreamPlayer.play()
	timer_15.start()
	await transformacion.finished
	canvas_layer.hide()
	get_tree().paused = false
	await animar_alpha(nemi, 0, 1, 1.5)
	
	await _mostrar_dialogo([
		"Hola, mi nombre es Nemi, soy una parte de Nemesis.",
		"Nemesis es una Inteligencia artificial diseñada originalmente para ayudar a la humanidad.", 
		"Sus servidores centrales se han visto corrompidos y han sido alimentados con odio e ira.",
		"Pero no te preocupes, fui diseñado para traerla a la normalidad una vez pasaran cosas como estas.",
		"Te enviaré a los servidores de Nemesis, seguramente tendrás que a travesar a un par de pruebas para llegar al centro pero no te preocupes.",
		"Yo estaré aquí para ayudarte.",
		"Te deseo surte..."
		])
	
	await animar_alpha(nemi, 1, 0, 1.5)
	
	get_tree().change_scene_to_file("res://control.tscn")

	
func animar_alpha(nodo: Node, desde: float, hasta: float, duracion: float) -> Signal:
	nodo.modulate.a = desde
	var tw := create_tween()
	tw.tween_property(nodo, "modulate:a", hasta, duracion)
	await tw.finished
	return tw.finished

func _mostrar_dialogo(textos: Array) -> void:
	var balloon_scene = load("res://mision5/Kruskal/Scenes/example_balloon.tscn").instantiate()
	add_child(balloon_scene)
	balloon_scene.show_messages(textos)
	
	while balloon_scene.balloon.visible:
		await get_tree().process_frame


func _on_timer_15_timeout() -> void:
		audio_extra.play()
