extends Node
class_name Arbol

func agregar(dato: String, link:String) -> void:
	var nuevo_nodo = Nodo.new(dato, link)
	if Global.raiz == null:
		Global.raiz = nuevo_nodo
		#print("Raiz: ", nuevo_nodo.dato)
	else:
		_agregar_recursivo(Global.raiz, nuevo_nodo)
	registrar_nodo(nuevo_nodo)

func _agregar_recursivo(actual: Nodo, nuevo: Nodo) -> void:
	if nuevo.dato < actual.dato:
		if actual.izquierda == null:
			actual.izquierda = nuevo
			nuevo.padre = actual
			print(nuevo.padre.dato, " padre de ", actual.izquierda.dato)
		else:
			_agregar_recursivo(actual.izquierda, nuevo)
	else:
		if actual.derecha == null:
			actual.derecha = nuevo
			nuevo.padre = actual
			print(nuevo.padre.dato, " padre de ", actual.derecha.dato)
		else:
			_agregar_recursivo(actual.derecha, nuevo)

func registrar_nodo(nodo: Nodo):
	Global.mapa_links[nodo.link] = nodo

func volver_padre(link: String):
	#print("LinkRecibido: ", link)
	var nodo_actual = Global.mapa_links.get(link, null)
	#print("nodoActual: ", nodo_actual)
	var link_padre = nodo_actual.padre.link
	#print("LinkPadre: ", nodo_actual)
	get_tree().change_scene_to_file(link_padre)
	

func ir_izq(link: String):
	print("LinkRecibido: ", link)
	var nodo_actual = Global.mapa_links.get(link, null)
	print("MAPA: ", Global.mapa_links)
	print("nodo_actual: ", nodo_actual)
	var izq= nodo_actual.izquierda
	GlobalTree.tree_printer()
	print("izq: ", izq)
	var DatoIzq= nodo_actual.izquierda
	print("NombreIzq: ", DatoIzq)
	link = izq.link
	print("linkIzq: ", link)
	get_tree().change_scene_to_file(link)
	

func ir_der(link: String):
	var nodo_actual = Global.mapa_links.get(link, null)
	var link_der= nodo_actual.derecha.link
	get_tree().change_scene_to_file(link_der)
	

func altura(nodo: Nodo = Global.raiz) -> int:
	if nodo == null:
		return 0
	return max(altura(nodo.izquierda), altura(nodo.derecha)) + 1

func get_col(h: int) -> int: 
	if h == 1: 
		return 1 
	return get_col(h - 1) + get_col(h - 1) + 1

func peso(nodo: Nodo = Global.raiz) -> int:
	if nodo == null:
		return 0
	return 1 + peso(nodo.izquierda) + peso(nodo.derecha)

func nivel(nodo: Nodo, buscar: String, nivel_actual: int = 0) -> int:
	if nodo == null:
		return -1
	if nodo.dato == buscar:
		return nivel_actual
	if buscar < nodo.dato:
		return nivel(nodo.izquierda, buscar, nivel_actual + 1)
	else:
		return nivel(nodo.derecha, buscar, nivel_actual + 1)

func print_binary_tree(M: Array, root: Nodo, col: int, row: int, height: int) -> void:
	if root == null:
		return
	
	M[row][col] = root.dato
	
	print_binary_tree(M, root.izquierda, col - int(pow(2, height - 2)), row + 1, height - 1)
	
	print_binary_tree(M, root.derecha, col + int(pow(2, height - 2)), row + 1, height - 1)

func tree_printer() -> void:
	var h = altura(Global.raiz)          
	var col = get_col(h)
	
	var M: Array = []
	for i in range(h):
		var fila = []
		for j in range(col):
			fila.append(0)
		M.append(fila)
	
	@warning_ignore("integer_division")
	print_binary_tree(M, Global.raiz, col / 2, 0, h)
	
	for i in range(h):
		var linea = ""
		for j in range(col):
			if str(M[i][j]) == "0":
				linea += "		"
			else:
				linea += str(M[i][j]) + " "
		print(linea)

func _inorden_lista(nodo: Nodo, lista: Array) -> Array:
	if nodo == null:
		return lista
	_inorden_lista(nodo.izquierda, lista)
	lista.append(nodo.dato)
	_inorden_lista(nodo.derecha, lista)
	return lista

func pad_center(s: String, width: int) -> String:
	var ln = s.length()
	if width <= ln:
		return s
	var total = width - ln
	@warning_ignore("integer_division")
	var left = int(total / 2)
	var right = total - left
	return " ".repeat(left) + s + " ".repeat(right)
