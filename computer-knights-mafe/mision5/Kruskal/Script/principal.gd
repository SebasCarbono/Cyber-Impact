# --- Script principal de la escena ---
extends Node2D

const PESO_BYTE = 2
const PESO_PATH =3
const PESO_HERO = 1
const PESO_CORRUPT = 1  # puedes cambiarlo si quieres
var fuenteEsc = false
var Sumi = false
var agentes_instanciados := []
var limite_flujo = 0
var perdio = false
@onready var temporizador = Timer.new()

@onready var nodos = [
	$Nodos/v1, $Nodos/v2, $Nodos/v3, $Nodos/v4,
	$Nodos/v5, $Nodos/v6, $Nodos/v7, $Nodos/v8, $Nodos/v9
]

@onready var nodos2 = [
	$Nodos/v1/Red, $Nodos/v2/Red, $Nodos/v3/Red, $Nodos/v4/Red,
	$Nodos/v5/Red, $Nodos/v6/Red, $Nodos/v7/Red, $Nodos/v8/Red, $Nodos/v9/Red
]
@onready var aristas = [
]

var byte = load("res://mision5/Kruskal/Scenes/byte.tscn").instantiate()
var path = load("res://mision5/Kruskal/Scenes/path.tscn").instantiate()
var corrupt = load("res://mision5/Kruskal/Scenes/corrupto.tscn").instantiate()
var V := 9
var edges := []        
var kruskal : Kruskal
var suma_mst := 0
var red_reconstruida := false
var fuente := -1
var sumidero := -1
var recorrido = []
var aristas_indices = [
		[0,2],[1,3],[0,1],[2,3],[1,4],[3,4],[2,7],
		[7,8],[3,5],[5,6],[7,6],[4,6],[8,6]
	]


func _ready():
	$CanvasLayer/Temporal.visible = false
	$CanvasLayer/Maximo.visible = false
	_mostrar_dialogo([
		"¡Nemesis ha desactivado el sistema de flujo de datos!",
		"Estamos a oscuras… si no lo reconstruimos pronto, todo colapsará.",
		"Necesito tu ayuda: restaura el sistema con el menor costo posible.",
		"Selecciona las aristas correctas… cada decisión cuenta.",
		"Recuerda, los caminos sin piedras son más rápidos de recorrer y requieren menos esfuerzo."
	])
	Global.game_over_mostrado = true
	add_child(temporizador)
	temporizador.one_shot = true
	$CanvasLayer/BlueRectangle.visible = false
	$"CanvasLayer/path".visible = false
	$"CanvasLayer/1".visible = false
	$"CanvasLayer/hero".visible = false
	randomize()
	kruskal = Kruskal.new(V)
	kruskal.kruskal_mst_edges()
	aristas = [
		$Aristas/linea, $Aristas/linea2, $Aristas/Linea3,
		$Aristas/Linea4, $Aristas/Linea5, $Aristas/Linea6,
		$Aristas/Linea7, $Aristas/Linea8, $Aristas/Linea9,
		$Aristas/Linea10, $Aristas/Linea11, $Aristas/Linea12,
		$Aristas/Linea13
	]

	edges.clear()
	for i in range(aristas_indices.size()):
		var o = aristas_indices[i][0]
		var d = aristas_indices[i][1]
		var w = randi_range(20,60)
		edges.append([o,d,w])
		kruskal.add_edge(o,d,w)
		kruskal.add_edge_WP(o,d)
		aristas[i].set_datos(o,d,w)

	suma_mst = kruskal.kruskal_mst()
	print("Suma mínima Kruskal:", suma_mst)
	var mst_set := {}

	# 1. Normalizar el MST (convertir nodos a string "a-b")
	for e in kruskal.get_edges_without_weight():
		var a = int(e[0])
		var b = int(e[1])
		if a > b:
			var temp = a
			a = b
			b = temp
		mst_set[str(a) + "-" + str(b)] = true

	# 2. Actualizar texturas de las aristas según MST
	for i in range(aristas.size()):
		var a = int(aristas_indices[i][0])
		var b = int(aristas_indices[i][1])
		if a > b:
			var temp = a
			a = b
			b = temp

		var key = str(a) + "-" + str(b)

		if mst_set.has(key):
			aristas[i].set_textura(preload("res://mision5/images/Normal.png"))
		else:
			aristas[i].set_textura(preload("res://mision5/images/Bad.png"))



func _process(delta: float) -> void:
	$CanvasLayer/Temporal.text = "Flujo: " + str(Global.peso_total)
	$CanvasLayer/Maximo.text = "Flujo máximo: " + str(limite_flujo)
	if Global.peso_total > limite_flujo :
		Global.peso_total = 0
		Global.daño = 0
		get_tree().change_scene_to_file("res://mision5/Scenes/game_over.tscn")
	if Global.peso_total < limite_flujo and Global.daño == 12:
		Global.kruskal = true
		get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/control.tscn")

func verificar_suma()  -> bool:
	var suma_usuario = 0
	var aristas_usuario = []
	var nu = 0
	
	for ar in aristas:
		if ar.seleccionada:
			suma_usuario += ar.peso
			var u_int = int(ar.origen)
			var v_int = int(ar.destino)
			aristas_usuario.append([min(u_int, v_int), max(u_int, v_int)])
			recorrido.append([u_int, v_int])  # ← SIN ERRORES
	# Normalizar MST guardado en Kruskal
	var mst_real = []
	for e in kruskal.kruskal_mst_edges():
		var a = int(e[0])
		var b = int(e[1])
		mst_real.append([min(a, b), max(a, b)])
	aristas_usuario.sort()
	mst_real.sort()
	for ar in aristas:
		if ar.seleccionada:
			var tween = create_tween()
			tween.tween_property(ar.sprite, "modulate", Color(0,1,0), 0.2)
			tween.tween_property(ar.sprite, "modulate", Color(1,1,1), 0.2)
			ar.sprite.texture = preload("res://mision5/images/Normal.png")
		else:
			ar.sprite.modulate = Color(0.5,0.5,0.5)  # sin modulación
	if aristas_usuario == mst_real:
		red_reconstruida = true
		_pantalla_tembla()
		for ar in aristas:
			ar.get_node("CollisionShape2D").disabled = true
		return true
	else:
		
		return false

func _on_button_pressed():
	if verificar_suma():
		$CanvasModulate.visible = false
		seleccionar_fuente(0)
		seleccionar_sumidero(6)

		var flujo_maximo = ford_fulkerson(fuente, sumidero)
		limite_flujo = flujo_maximo
		Global.peso_total = 0
		agentes_instanciados.clear()
		_mostrar_dialogo([
			"Parece que a Nemesis no le agrada para nada nuestra llegada…",
			"¡Ha liberado archivos corruptos para desestabilizar toda la red!",
			"Pero no estamos solos: los trillizos Byte, Path y Hero están listos para enfrentarlos.",
			"Path pesa 3, Byte pesa 2 y Hero pesa 1…",
			"¡Úsalos con sabiduría, tú puedes!"
		])
		
		var tween = create_tween()
		tween.parallel().tween_property($Nodos, "position:x", $Nodos.position.x + 100, 1.5)
		tween.parallel().tween_property($Aristas, "position:x", $Aristas.position.x + 100, 1.5)
		tween.parallel().tween_property($CanvasLayer/Button, "position:x", $CanvasLayer/Button.position.x + 100, 1.5)
		await tween.finished
		$CanvasLayer/Button.visible = false
		$CanvasLayer/BlueRectangle.visible = true
		$"CanvasLayer/1".visible = true
		$"CanvasLayer/path".visible = true
		$"CanvasLayer/hero".visible = true
		$CanvasLayer/Temporal.visible = true
		$CanvasLayer/Maximo.visible = true 
		$CanvasLayer/Path.visible = true
		$CanvasLayer/Hero.visible = true
		$CanvasLayer/Byte.visible = true
		var camino = generar_camino_mst(fuente, sumidero)
	
		aparicionVillano()
		corrupt.position = nodos2[sumidero].global_position
		corrupt.set_path(camino)
		byte.set_path(camino)
	else:
		get_tree().change_scene_to_file("res://mision5/Scenes/game_over.tscn")
# --- Selección de fuente y sumidero ---
func seleccionar_fuente(indice):
	if not red_reconstruida: return
	fuente = indice
	nodos[indice].modulate = Color(0,0.5,1)

func seleccionar_sumidero(indice):
	sumidero = indice
	nodos[indice].modulate = Color(0,1,0)


func ford_fulkerson(source, sink):
	var grafo = crear_grafo_capacidades()
	var camino = bfs_camino(grafo, source, sink)
	if camino.is_empty():
		return 0  # No hay flujo posible
	var capacidad_min = INF
	for edge in camino:
		capacidad_min = min(capacidad_min, grafo[edge[0]][edge[1]])
	print(capacidad_min)
	return capacidad_min
	
func crear_grafo_capacidades():
	var g = []
	for i in range(V):
		g.append([])
		for j in range(V):
			g[i].append(0)
	for e in edges:
		var origen = e[0]
		var destino = e[1]
		var base_capacidad = e[2]
		# --- Modificador base ---
		var modificador = 1.0
		# --- Ajustar si alguno pertenece a un grupo específico ---
		if nodos[origen].is_in_group("enemigos") or nodos[destino].is_in_group("enemigos"):
			modificador = 0.5  # Menor capacidad si hay enemigo
		elif nodos[origen].is_in_group("heroes") and nodos[destino].is_in_group("heroes"):
			modificador = 1.5  # Mayor capacidad si ambos son héroes
		# --- Asignar capacidad ajustada ---
		var capacidad_final = base_capacidad * modificador
		g[origen][destino] = capacidad_final
		g[destino][origen] = capacidad_final  # bidireccional
	return g



func bfs_camino(grafo, s, t):
	var visited = []
	var parent = []
	for i in range(V):
		visited.append(false)
		parent.append(-1)
	var queue = [s]
	visited[s] = true
	while queue.size() > 0:
		var u = queue.pop_front()
		for v in range(V):
			if not visited[v] and grafo[u][v] > 0:
				queue.append(v)
				visited[v] = true
				parent[v] = u
	if not visited[t]:
		return []
	var path = []
	var v = t
	while v != s:
		path.append([parent[v], v])
		v = parent[v]
	return path

# --- Genera camino para el Byte usando solo aristas seleccionadas ---
func generar_camino_mst(fuente, sumidero) -> Array:
	var grafo = {}
	for i in range(V):
		grafo[i] = []
	for ar in aristas:
		if ar.seleccionada:
			grafo[ar.nodo_a_idx].append(ar.nodo_b_idx)
			grafo[ar.nodo_b_idx].append(ar.nodo_a_idx)


	# BFS para camino
	var visited = []
	var parent = []
	for i in range(V):
		visited.append(false)
		parent.append(-1)
	var queue = [fuente]
	visited[fuente] = true
	while queue.size() > 0:
		var u = queue.pop_front()
		for v in grafo[u]:
			if not visited[v]:
				queue.append(v)
				visited[v] = true
				parent[v] = u

	var path = []
	if not visited[sumidero]:
		return path
	var v = sumidero
	while v != fuente:
		path.insert(0, nodos2[v].global_position)
		v = parent[v]
	path.insert(0, nodos2[fuente].global_position)
	return path

# --- Efectos visuales y mensajes ---
func _mostrar_dialogo(textos: Array):
	var balloon_scene = load("res://mision5/Kruskal/Scenes/example_balloon.tscn").instantiate()
	add_child(balloon_scene)
	balloon_scene.show_messages(textos)

func _pantalla_tembla():
	var duracion := 0.8
	var fuerza := 10.0
	var original_pos := position
	var tween := create_tween()
	for i in range(10):
		var offset := Vector2(randf_range(-fuerza, fuerza), randf_range(-fuerza, fuerza))
		tween.tween_property(self, "position", original_pos + offset, duracion / 10.0)
	tween.tween_property(self, "position", original_pos, 0.1)

func aparicionVillano():
	for i in range(12): # cantidad de villanos que aparecerán
		var corrupt = load("res://mision5/Kruskal/Scenes/corrupto.tscn").instantiate()
		add_child(corrupt)
		Global.peso_total += PESO_CORRUPT
		_pantalla_tembla()
		corrupt.position = nodos2[sumidero].global_position
		var camino = generar_camino_mst(fuente, sumidero)
		corrupt.set_path(camino)
		
		await get_tree().create_timer(4.0).timeout # espera 2 segundos antes de crear el siguiente
	

func _desactivar_botones(bt):
	bt.disabled = true
	bt.modulate = Color(1, 1, 1, 0.5)

	temporizador.wait_time = 1.5
	temporizador.start()
	await temporizador.timeout

	bt.disabled = false
	bt.modulate = Color(1, 1, 1, 1)
	
func _activar_botones():
	$"CanvasLayer/1".disabled = false
	$CanvasLayer/path.disabled = false
	$"CanvasLayer/1".modulate = Color(1, 1, 1, 1)
	$CanvasLayer/path.modulate = Color(1, 1, 1, 1)

# --- Botón que lanza al Byte ---
func _on__pressed() -> void:
	_desactivar_botones($"CanvasLayer/1")

	var nuevo_byte = load("res://mision5/Kruskal/Scenes/byte.tscn").instantiate()
	nuevo_byte.position = nodos2[fuente].global_position
	$CanvasLayer.add_child(nuevo_byte)
	Global.peso_total += PESO_BYTE
	var camino = generar_camino_mst(fuente, sumidero)
	nuevo_byte.set_path(camino)

func _on_path_pressed() -> void:
	_desactivar_botones($CanvasLayer/path)

	var paths = load("res://mision5/Kruskal/Scenes/path.tscn").instantiate()
	paths.position = nodos2[fuente].global_position
	$CanvasLayer.add_child(paths)
	#add_child(paths)
	Global.peso_total += PESO_PATH
	var camino = generar_camino_mst(fuente, sumidero)
	paths.set_path(camino)


func _on_hero_pressed() -> void:
	_desactivar_botones($CanvasLayer/hero)
	var paths = load("res://mision5/Kruskal/Scenes/hero.tscn").instantiate()
	paths.position = nodos2[fuente].global_position
	$CanvasLayer.add_child(paths)
	#add_child(paths
	Global.peso_total += PESO_HERO

	var camino = generar_camino_mst(fuente, sumidero)
	paths.set_path(camino)


func _on_animated_sprite_2d_animation_finished() -> void:
	$CanvasLayer/TextEdit.ya = true
	$CanvasLayer/TextEdit.visible = true
	$CanvasLayer/TextEdit._timer.start()



func _on_v_1_body_entered(body: CharacterBody2D) -> void:
	print("JJJJJ")
	if body.is_in_group("BAD"):
		#get_tree().change_scene_to_file("res://mision5/Scenes/game_over.tscn")
		_pantalla_tembla()
