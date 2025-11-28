extends Node2D

var imagenes = [
	"res://Images/ChatGPT Image 9 oct 2025, 07_38_28 p.m..png",
	"res://Images/ChatGPT Image 9 oct 2025, 08_36_47 p.m..png",
	"res://Images/ChatGPT Image 9 oct 2025, 08_41_50 p.m..png"
]

@onready var sprite = $gmails  # Tu Sprite2D
var imagenes_disponibles = []

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	if imagenes_disponibles.is_empty():
		imagenes_disponibles = imagenes.duplicate()
	mostrar_imagen_aleatoria()

func mostrar_imagen_aleatoria():
	if imagenes_disponibles.is_empty():
		print("Se acabaron todas las imágenes")
		return
	
	var indice = rng.randi_range(0, imagenes_disponibles.size() - 1)
	var ruta = imagenes_disponibles[indice]
	sprite.texture = load(ruta)
	imagenes_disponibles.remove_at(indice)

func _on_mail_1_pressed() -> void:
	if sprite.texture.resource_path == "res://Images/ChatGPT Image 9 oct 2025, 07_38_28 p.m..png":
		Global.perdio = true
		get_tree().change_scene_to_file("res://Scenes/inbox.tscn")
	elif sprite.texture.resource_path == "res://Images/ChatGPT Image 9 oct 2025, 08_36_47 p.m..png":
		Global.perdio = true
		get_tree().change_scene_to_file("res://Scenes/inbox.tscn")
	else:
		Global.perdio = true
		get_tree().change_scene_to_file("res://Scenes/inbox.tscn")



func _on_mail_2_pressed() -> void:
	if sprite.texture.resource_path == "res://Images/ChatGPT Image 9 oct 2025, 07_38_28 p.m..png":
		Global.perdio = true
		get_tree().change_scene_to_file("res://Scenes/inbox.tscn")
	elif sprite.texture.resource_path == "res://Images/ChatGPT Image 9 oct 2025, 08_36_47 p.m..png":
		Global.perdio = false
		get_tree().change_scene_to_file("res://Scenes/inbox.tscn")
	else:
		Global.perdio = false
		get_tree().change_scene_to_file("res://Scenes/inbox.tscn")



func _on_mail_3_pressed() -> void:
	if sprite.texture.resource_path == "res://Images/ChatGPT Image 9 oct 2025, 07_38_28 p.m..png":
		Global.perdio = false
		get_tree().change_scene_to_file("res://Scenes/inbox.tscn")
	elif sprite.texture.resource_path == "res://Images/ChatGPT Image 9 oct 2025, 08_36_47 p.m..png":
		Global.perdio = true
		get_tree().change_scene_to_file("res://Scenes/inbox.tscn")
	else:
		Global.perdio = true
		get_tree().change_scene_to_file("res://Scenes/inbox.tscn")
