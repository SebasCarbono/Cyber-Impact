extends Node
var Speed_x = 200

var peso_total = 0
var kruskal = false
var daño = 0
var gameOver = false
var lose = false
var desicion = ""
var game_over_mostrado = false

var tree = Arbol.new()
var escena
func _ready() -> void:
	#GlobalTree.agregar("Entrada", "res://escenas/Escena_principal.tscn")
	GlobalTree.agregar("Inicio","res://Scenes/computador.tscn")
	GlobalTree.agregar("Correo","res://Scenes/inbox.tscn")
	GlobalTree.agregar("Navegador", "res://Scenes/Google.tscn")
	#GlobalTree.agregar("Dragon","res://src/Battle.tscn" )
	GlobalTree.agregar("Folder","res://Scenes/Carpets.tscn")
	#GlobalTree.agregar("Diversión", "res://Scenes/NodoSeguro.tscn")
	GlobalTree.agregar("Battle","res://findemor-youtube-aprender-godot-1.0.2/niveles/level_1.tscn")
	GlobalTree.agregar("Bomba", "res://mision5/DijkstraMinigame/scene/control.tscn")
	GlobalTree.tree_printer()

var mapa_links = {}
var escenaCompletada = []
var raiz = null
var caminoEquivocado = "res://Scenes/caminoEquivocado.tscn"
var escena_anterior = ""
var texto_mostrado = false
var texto_mostradoC = false
var perdio = false
var gmail = false
var google = false
var googleya = false
var count = 0
var gano= false
var termino = false

func camino_equivocado():
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(Global.caminoEquivocado)

func añadirCompletado(link:String):
	if escenaCompletada.has(link):
		return
	escenaCompletada.append(link)
	

func globalPause():
	get_tree().paused = true

func globalUnpause():
	get_tree().paused = false
