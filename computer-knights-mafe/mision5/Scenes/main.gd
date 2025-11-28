extends Node

var vertices = []
var graf: grafo
var recorPlayer = []
var n = 0
@onready var transformacion = $CanvasLayer/VideoStreamPlayer
@onready var canvas_layer = $CanvasLayer
func _ready() -> void:
	
	get_tree().paused = true
	transformacion.play()
	await transformacion.finished
	canvas_layer.hide()
	get_tree().paused = false
	
	await _mostrar_dialogo([
		"¡¿Qué es eso?! Parece un Pac-Man ?...",
		"Mira el grafo en la esquina inferior izquierda… está tomando forma.",
		"Si seguimos el recorrido que trazamos… tendremos que replicarlo en la vida real.",
		"Sí… lo sé. Suena completamente insano.",
		"¡Y cuidado! Los virus están al acecho… quieren destrozar el sistema. ¡No te dejes atrapar!"
	])

	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D2.visible = false
	$Button.visible = false
	$Button2.visible = false
	vertices = [$Vertices/vertice,$Vertices/vertice2,$Vertices/vertice3,$Vertices/vertice4,$Vertices/vertice5,$Vertices/vertice6, $Vertices/vertice7]
	graf = grafo.new()
	var v1 = vertice.new(vertices[0].nombre)
	var v2 = vertice.new(vertices[1].nombre)
	var v3 = vertice.new(vertices[2].nombre)
	var v4 = vertice.new(vertices[3].nombre)
	var v5 = vertice.new(vertices[4].nombre)
	var v6 = vertice.new(vertices[5].nombre)
	var v7 = vertice.new(vertices[6].nombre)
	
	graf.agregar_vertice(v1)
	graf.agregar_vertice(v2)
	graf.agregar_vertice(v3)
	graf.agregar_vertice(v4)
	graf.agregar_vertice(v5)
	graf.agregar_vertice(v6)
	graf.agregar_vertice(v7)
	
	graf.conectar_vertice(v1, v2)
	graf.conectar_vertice(v1, v3)
	graf.conectar_vertice(v1, v4)
	graf.conectar_vertice(v2, v3)
	graf.conectar_vertice(v2, v4)
	graf.conectar_vertice(v3, v5)
	graf.conectar_vertice(v3, v4)
	graf.conectar_vertice(v4, v5)
	graf.conectar_vertice(v4, v6)
	graf.conectar_vertice(v5, v7)
	graf.conectar_vertice(v6, v7)
	graf.conectar_vertice(v1, v7)
	resaltar_siguiente_correcto("A")
	
var glitch_timer := 0.0
func resaltar_siguiente_correcto(nombre):
	var resultado
	if VGlobal.desicion == "BFS":
		resultado = graf.BFS(0)
	else:
		resultado = graf.DFS(0)

	# cuántos ha hecho el jugador
	var index := recorPlayer.size()

	# si ya completó todo, salir
	if index >= resultado.size():
		return

	# siguiente correcto
	var siguiente = resultado[index]

	# --- ¿SE EQUIVOCÓ? ---
	if nombre != resultado[index - 1] and index > 0:
		shake_screen()
		titilar_nodos_error()
		return

	# --- TITILEAR EL SIGUIENTE CORRECTO ---
	for v in vertices:
		if v.nombre == siguiente:

			var original = v.sprite.texture

			var tw := create_tween()
			tw.set_loops(6)

			# textura brillante
			tw.tween_callback(func():
				v.sprite.texture = preload("res://mision5/Node.png")
			).set_delay(0.12)

			# textura normal
			tw.tween_callback(func():
				v.sprite.texture = original
			).set_delay(0.12)

		else:
			v.sprite.modulate = Color(1, 1, 1)



#func _process(delta):
	#glitch_timer -= delta
	#if glitch_timer <= 0:
		#glitch_global()
		#glitch_timer = randf_range(1.0, 3.0)  # cada glitch ocurre entre 1 y 3 segundos
	
func titilar_nodos_error():
	for v in vertices:
		var tw = create_tween()
		tw.set_loops(6)  # número de parpadeos

		tw.tween_callback(func():
			v.modulate = Color(randf(), randf(), randf())  # color aleatorio
		).set_delay(0.1)

		tw.tween_callback(func():
			v.modulate = Color.WHITE
		).set_delay(0.1)

func shake_screen(intensidad := 10.0, duracion := 0.4):
	if not has_node("Camera2D"):
		return

	var cam = $Camera2D
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_SINE)
	tw.set_ease(Tween.EASE_IN_OUT)

	var tiempo := 0.0
	tw.tween_method(func(delta):
		if tiempo < duracion:
			cam.offset = Vector2(
				randf_range(-intensidad, intensidad),
				randf_range(-intensidad, intensidad)
			)
			tiempo += delta
		else:
			cam.offset = Vector2.ZERO
	, 0.0, duracion, duracion)

func save(nombre) -> void:
	recorPlayer.append(nombre)
	n += 1
	resaltar_siguiente_correcto(nombre)
	if n == 7:
		var resultado
		if VGlobal.desicion == "BFS":
			resultado = graf.BFS(0)
		else:
			resultado = graf.DFS(0)

		print("Resultado:", resultado)
		print("Jugador: ", recorPlayer)

		if resultado == recorPlayer:
			VGlobal.pacman = true
			get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/control.tscn")
		else:
			perdio()

func perdio():
	graf = grafo.new()
	$UI.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D2.visible = true
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D2.play("new_animation")
	await _mostrar_dialogo(["Tonto humano", "¿Pensaste que podrías ganarle a un ser superior?", "JAJAJAJA", "¿Quieres rendirte o tener tu revancha?"])
	_show_buttons_sequence()
	
func _mostrar_dialogo(textos: Array) -> void:
	var balloon_scene = load("res://mision5/Kruskal/Scenes/example_balloon.tscn").instantiate()
	add_child(balloon_scene)
	balloon_scene.show_messages(textos)

	# Esperar hasta que balloon.visible sea false (cuando ya no hay más mensajes)
	while balloon_scene.balloon.visible:
		await get_tree().process_frame

func _show_buttons_sequence():
	await get_tree().create_timer(1.0).timeout
	$Button.visible = true
	var tween1 = create_tween()
	tween1.tween_property($Button, "modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE)

	tween1.tween_callback(func():
		$Button2.visible = true
		var tween2 = create_tween()
		tween2.tween_property($Button2, "modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE)
	)

#func glitch_global():
	## Ralentiza el juego sin teletransportar
	#Engine.time_scale = 0.2   # todo va al 20% de velocidad
#
	## (Opcional) glitch visual de cámara
	#if has_node("Camera2D"):
		#$Camera2D.offset = Vector2(randf_range(-12, 12), randf_range(-12, 12))
#
	#await get_tree().create_timer(0.15, true).timeout
#
	## Restaurar velocidad normal
	#Engine.time_scale = 1.0
#
	## Restaurar cámara
	#if has_node("Camera2D"):
		#$Camera2D.offset = Vector2.ZERO


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://mision5/Scenes/main.tscn")


func _on_button_2_pressed() -> void:
	VGlobal.pacman = false
	get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/control.tscn")
