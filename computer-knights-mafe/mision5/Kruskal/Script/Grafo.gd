# Grafo.gd
extends Node
class_name grafo

var matriz_adyacencia
var adyacentes_grafo := []

# Constructor
func _init():
	adyacentes_grafo = []

# Agregar vértice
func agregar_vertice(vertice):
	# asigna id consistente (posición en el arreglo)
	vertice.id = adyacentes_grafo.size()
	adyacentes_grafo.append(vertice)

	# expandir/crear matriz_adyacencia
	if matriz_adyacencia == null:
		matriz_adyacencia = [[0]] # primer vértice
	else:
		var n = matriz_adyacencia.size()
		# añadir una columna (0) a cada fila existente
		for i in range(n):
			matriz_adyacencia[i].append(0)
		# añadir nueva fila con n+1 ceros
		var new_row := []
		for j in range(n + 1):
			new_row.append(0)
		matriz_adyacencia.append(new_row)

# Conectar dos vértices
func conectar_vertice(v1, v2):
	if matriz_adyacencia == null:
		var n = adyacentes_grafo.size()
		matriz_adyacencia = []
		for i in range(n):
			matriz_adyacencia.append([])
			for j in range(n):
				matriz_adyacencia[i].append(0)
	
	v1.agregar_adyacente(v2)
	v2.agregar_adyacente(v1)
	matriz_adyacencia[v1.id][v2.id] = 1
	matriz_adyacencia[v2.id][v1.id] = 1

# Imprimir lista de adyacencia
func imprimir_lista():
	for vertice in adyacentes_grafo:
		print(vertice)

# Imprimir matriz de adyacencia
func imprimir_matriz_adyacencia():
	if matriz_adyacencia == null:
		print("El grafo no tiene conexiones.")
		return

	print("\nMatriz de adyacencia:")
	var header = "    "
	for v in adyacentes_grafo:
		header += str(v.dato) + " "
	print(header)

	for i in range(matriz_adyacencia.size()):
		var row = ""
		for j in range(matriz_adyacencia[i].size()):
			row += "   " + str(matriz_adyacencia[i][j])
		print(row)

func BFS(inicio: int) -> Array:
	var visitados = []
	for _i in adyacentes_grafo:
		visitados.append(false)

	var cola = []
	var recorrido = []

	visitados[inicio] = true
	cola.append(inicio)

	while cola.size() > 0:
		var ahora = cola.pop_front()

		# ⬇ ahora añade el nombre del vértice (string)
		recorrido.append( adyacentes_grafo[ahora].dato )

		for v in adyacentes_grafo[ahora].adyacentes:
			var indice = v.id
			if not visitados[indice]:
				visitados[indice] = true
				cola.append(indice)

	return recorrido

# DFS recursivo
func dfs_recursive(inicio: int):
	var visitados = []
	for _i in adyacentes_grafo:
		visitados.append(false)
	_dfs_recursive_helper(inicio, visitados)

func _dfs_recursive_helper(actual: int, visitados: Array):
	visitados[actual] = true
	print(adyacentes_grafo[actual])
	for v in adyacentes_grafo[actual].adyacentes:
		if not visitados[v.id]:
			_dfs_recursive_helper(v.id, visitados)

func DFS(inicio: int) -> Array:
	var visitados = []
	for _i in adyacentes_grafo:
		visitados.append(false)
	
	var recorrido = []
	var pila = []
	pila.append(inicio)

	while pila.size() > 0:
		var ahora = pila.pop_back()
		if not visitados[ahora]:
			visitados[ahora] = true

			# Guardamos nombre en vez de índice
			recorrido.append( adyacentes_grafo[ahora].dato )

			var actual = adyacentes_grafo[ahora]
			var menor = null
			for v in actual.adyacentes:
				if not visitados[v.id]:
					if menor == null or str(v.dato) < str(menor.dato):
						menor = v
			if menor != null:
				pila.append(menor.id)

	return recorrido
