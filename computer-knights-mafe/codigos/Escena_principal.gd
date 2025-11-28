extends Node3D

@onready var caja: Node3D = $caja

var tiene_llave = false #si tiene o no tiene la llave de candado
var puerta_abierta = false #si la puerta esta o no abierta

var nodo_animation_candado #esta variable la uso para buscar los nodos en la funcion ready
var nodo_animation_puerta #esta variable la uso para buscar los nodos en la funcion ready
var nodo_Area_candado
var muerto = false #si esta muerto o vivo

@export var tiempo_antes_de_conteo = 10 #variable para determinar cuantas veces tiene que reproducirse el sonido tiempo conteo
var played_one = false #esta variable es para que se ejecute 1 ves sola el timer conteo en el update ya que el update se ejecuta 60 veses por segundo
var recorrido = []
var grafo
# Called when the node enters the scene tree for the first time.

func _ready():
	nodo_animation_candado = get_tree().get_nodes_in_group("animation_candado")[0]#la variable representa el nodo animacion candado que esta en la escena candado
	nodo_animation_puerta = get_tree().get_nodes_in_group("animation_laberinto_cuadrado")[0]#la variable representa el nodo animacion candado que esta en la escena candado
	nodo_Area_candado = get_tree().get_nodes_in_group("Area_candado")[0]#busco el nodo area candado
	
	
	grafo = Grafos.new()
	var v1 = Vertices.new("A")
	var v2 = Vertices.new("B")
	var v3 = Vertices.new("C")
	var v4 = Vertices.new("D")
	var v5 = Vertices.new("E")
	var v6 = Vertices.new("F")
	var v7 = Vertices.new("G")
	var v8 = Vertices.new("H")
	
	grafo.agregar_vertice(v1)
	grafo.agregar_vertice(v2)
	grafo.agregar_vertice(v3)
	grafo.agregar_vertice(v4)
	grafo.agregar_vertice(v5)
	grafo.agregar_vertice(v6)
	grafo.agregar_vertice(v7)
	grafo.agregar_vertice(v8)
	
	grafo.conectar_vertice(v1,v7)
	grafo.conectar_vertice(v6,v7)
	grafo.conectar_vertice(v4,v6)
	grafo.conectar_vertice(v1,v6)
	grafo.conectar_vertice(v4,v2)
	grafo.conectar_vertice(v4,v5)
	grafo.conectar_vertice(v2,v8)
	grafo.conectar_vertice(v6,v3)
	grafo.conectar_vertice(v5,v3)
	grafo.conectar_vertice(v5,v8)
	
	await _mostrar_dialogo([
		"En este nivel tienes que reconstruir una red de nodos para conseguir acceso a los servidores.",
		"Toma la llave y accede al laberitno.",
		"Una vez adentro, sigue los puntos en el minimapa y llegaras al final.",
		"Te espero del otro lado..."
	])
	caja.queue_free()

var n = 0

func _mostrar_dialogo(textos: Array) -> void:
	var balloon_scene = load("res://mision5/Kruskal/Scenes/example_balloon.tscn").instantiate()
	add_child(balloon_scene)
	balloon_scene.show_messages(textos)
	
	while balloon_scene.balloon.visible:
		await get_tree().process_frame

func save(nombre) -> void:
	var vs = [
		$laberintos/Laberinto_cuadrado/Area3D2,
		$laberintos/Laberinto_cuadrado/Area3D3,
		$laberintos/Laberinto_cuadrado/Area3D4,
		$laberintos/Laberinto_cuadrado/Area3D5,
		$laberintos/Laberinto_cuadrado/Area3D6,
		$laberintos/Laberinto_cuadrado/Area3D7,
		$laberintos/Laberinto_cuadrado/Area3D8,
		$laberintos/Laberinto_cuadrado/Area3D9
	]
	recorrido.append(nombre)
	n += 1

	var resultado
	if Global.desicion == "BFS":
		resultado = grafo.BFS(0)
	else:
		resultado = grafo.DFS(0)

	# Colorear nodos
	print(vs)
	for vertice_node in vs:
		if vertice_node.nombre == nombre:
			# Nodo actual: verde
			vertice_node._cambiar_color_correcto()
			vertice_node.parpadeando = false  # Detener parpadeo si estaba activo
		elif n < resultado.size() and vertice_node.nombre == resultado[n]:
			# Siguiente nodo: naranja parpadeando
			vertice_node._proximo_parpadeante()
		else:
			# Resetear color de otros nodos
			vertice_node.parpadeando = false
			# opcional: vertice_node._reset_color()

	# Verificar si se completó el recorrido
	if n == resultado.size():
		print("Resultado:", resultado)
		print("Jugador:", recorrido)

		if resultado == recorrido:
			print("Win")
			get_tree().change_scene_to_file("res://Scenes/computador.tscn")
		else:
			print("Game over")
			perdio()
			grafo = Grafos.new()
			get_tree().change_scene_to_file("res://GameOverTer.tscn")

		

func _process(delta):#esta funcion se repete 60 veces por segundo
	
	# Solo muestra el texto si el temporizador está activo (se activará al abrir el candado)
	if !$Timer_espera.is_stopped():
		$Interface_UI/tiempo_espera.text = "Tiempo de espera: " + str(int($Timer_espera.time_left) + 1)#cambio el texto de pantalla
	
	if muerto == true:#si esta muerto
		if Input.is_action_just_pressed("click_izquierdo") or Input.is_action_pressed("iniciar_touch"):#si presino click o el centro de la pantalla
			get_tree().change_scene_to_file("res://escenas/Menu_principal.tscn")#cambiamos a la escena preincipal
	
	#esto se tiene que ejecutar 1 ves y es para el conteo
	if !$Timer_espera.is_stopped() and int($Timer_espera.time_left) <= tiempo_antes_de_conteo and !played_one: #si el timer tiempo de espera esta activado y si int tiempo restante es menor o igual a 3 y si nunca se ejecuto
		$Timer_cuanto_falto.start()#ejecuto el timer para conteo
		played_one = true#ejectuar 1 ves sola esta linea de codigo
		
			

		
func _on_Area_candado_body_entered(body):#si un cuerpo entra al area
	if body.is_in_group("esfera"):#si ese cuerpo esta en un grupo esfera
		if tiene_llave == false: #sino tiene la llave
			nodo_animation_candado.play("candado_cerrado")#activa animacion candado cerrado
			$Musica_and_sfx/sfx_puerta_cerrada.playing = true#ejecuta sonido cuando no tenes la llave de la puerta
		
		if tiene_llave == true: #si tiene la llave, empezamos la nueva lógica
			
			# --- LÓGICA DE INICIO DE TIEMPO (NUEVO REQUERIMIENTO) ---
			$Interface_UI/tiempo_espera.visible = true # Hace que el texto de espera sea visible
			$Timer_espera.start() # ¡Inicia el temporizador aquí!
			$Musica_and_sfx/musica_normal.playing = false # Pauso música normal
			$Musica_and_sfx/musica_rapida.playing = true # Activo música más rapida
			# --- FIN LÓGICA DE INICIO DE TIEMPO ---
			
			nodo_animation_candado.play("candado_abierto")#activa animacion candado abierto
			$Musica_and_sfx/sfx_puerta_abierta.playing = true #activo sonido puerta abierta
			
			#esto esta relacionado a abrir la puerta
			await nodo_animation_candado.animation_finished#cuando termina la animación de candado abierto
			$Musica_and_sfx/sfx_puerta_abierta_2.playing = true#activo efecto sonido puerta 2
			nodo_animation_puerta.play("abrir_puerta")#se abre la puerta
			puerta_abierta = true#ya no puede volverse a abrir porque se abrio
			nodo_Area_candado.queue_free()#esto es para destruir el area donde esta el candado
			$candado.visible = false#esto hace invisible el candado"

			
func _on_llave_body_entered(body):
	if body.is_in_group("esfera"):#cuando entra un cuerpo a al area de la llave
		tiene_llave = true	#si entro la esfera tiene la llave
		$Musica_and_sfx/sfx_llave.playing = true #ejecuta sonido agarre llave
		
		# --- LÓGICA ANTERIOR DE TIEMPO REMOVIDA AQUÍ ---
		# $Musica_and_sfx/musica_normal.playing = false
		# $Musica_and_sfx/musica_rapida.playing = true
		# $Interface_UI/tiempo_espera.visible = true
		# $Timer_espera.start()
		# --- FIN DE LÓGICA REMOVIDA ---
		
		$llave_y_candado/llave.queue_free()#elimino la llave porque ya la tengo
		$animacion_mundo.play("claridad_mundo")
		


func _on_Timer_espera_timeout():
	$Timer_cuanto_falto.stop()#detengo el timer para conteo final
	$AnimationPlayerPrincipal.play("Game_over_animacion")#activa la animacion Game over
	$Interface_UI/tiempo_espera.visible = false#se deja de ver el texto tiempo de espera
	$personaje/esfera.queue_free()#destruyo la esfera
	$Interface_UI/colorfondoMuerte.visible = true #activa un fondo negro para mostrar que perdiste
	$Musica_and_sfx/musica_rapida.playing = false#desactivo la musica rapida
	$Musica_and_sfx/muerte_sonido.playing = true#activo sonido muerte
	$Musica_and_sfx/lose_sonido.playing = true#activo sonido lose sonido
	muerto = true #si paso el tiempo moriste


func _on_Timer_cuanto_falto_timeout():#cada ves que pasa 1 segundo en el conteo
	$Musica_and_sfx/conteo_sonido.playing = true#se ejecuta el sonido conteo
	
func desactivar_morir():
	$Timer_cuanto_falto.stop()
	$Timer_espera.stop()
	$animacion_mundo.play_backwards("claridad_mundo")#activa la animación pero al reves
	$Interface_UI/tiempo_espera.visible = false


func _on_area_winner_body_entered(body):
	if body.is_in_group("esfera"):
		desactivar_morir() # Detiene el temporizador y revierte la animación al ganar
		$Musica_and_sfx/winner_sonido.playing = true#activa sonido winner
		$Musica_and_sfx/musica_normal.playing = false#desactiva musica normal
		$Musica_and_sfx/musica_rapida.playing = false # Aseguramos que la música rápida pare
		$Interface_UI/Winner_texto.visible = true#hace visible el texto winner
		await $Musica_and_sfx/winner_sonido.finished#detengo el flujo de codigo hasta que termine el sonido
		$Interface_UI/Winner_texto.visible = false#hace visible el texto winner
		$AnimationPlayerPrincipal.play("Game_over_animacion")#activamos la animacion game over ya que teminaste el juego
		$personaje/esfera.sleeping = true
		muerto = true
		get_tree().change_scene_to_file("res://Scenes/computador.tscn")
		
func perdio():
	# Detener timers
	if $Timer_cuanto_falto:
		$Timer_cuanto_falto.stop()
	if $Timer_espera:
		$Timer_espera.stop()

	# Desactivar UI de juego
	if $UI:
		$UI.visible = false

	# Animación de muerte
	if $AnimationPlayerPrincipal:
		$AnimationPlayerPrincipal.play("Game_over_animacion")

	# Fondo negro
	if $Interface_UI/colorfondoMuerte:
		$Interface_UI/colorfondoMuerte.visible = true

	# Sonidos
	if $Musica_and_sfx/musica_normal:
		$Musica_and_sfx/musica_normal.playing = false
	
	if $Musica_and_sfx/musica_rapida:
		$Musica_and_sfx/musica_rapida.playing = false

	if $Musica_and_sfx/muerte_sonido:
		$Musica_and_sfx/muerte_sonido.playing = true

	if $Musica_and_sfx/lose_sonido:
		$Musica_and_sfx/lose_sonido.playing = true

	# Destroy jugador (como tu código original)
	if $personaje/esfera:
		$personaje/esfera.queue_free()

	# Activar modo “muerto”
	muerto = true
