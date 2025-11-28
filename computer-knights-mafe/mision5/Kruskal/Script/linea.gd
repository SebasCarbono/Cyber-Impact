extends Area2D

@export var nodo_a_idx: int = -1
@export var nodo_b_idx: int = -1
var peso: int

@onready var sprite = $Linea
@onready var label_peso = $Label
@export var origen = ""
@export var destino = ""
@export var textura_normal: Texture2D = preload("res://mision5/images/Normal.png")
@export var textura_alternativa: Texture2D = preload("res://mision5/images/selected.png")
var txturaBad = preload("res://mision5/images/Bad.png")
var tesxtureAlter = preload("res://mision5/images/selectedBad.png")
@export var brillo_color: Color = Color(0, 1, 1, 0.7)
@export var duracion_brillo: float = 0.2
var usando_alternativa := false
var brillo_timer := 0.0
var seleccionada := false

func _ready():
	if label_peso:
		label_peso.text = str(peso)
	sprite.texture = textura_normal
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		seleccionada = !seleccionada
		if sprite.texture == txturaBad or sprite.texture == tesxtureAlter:
			sprite.texture = tesxtureAlter if seleccionada else txturaBad
		else:
			sprite.texture = textura_alternativa if seleccionada else textura_normal
		
		if seleccionada:
			brillo_timer = duracion_brillo
			sprite.modulate = brillo_color
		else:
			sprite.modulate = Color(1, 1, 1, 1)

func _process(delta):
	if brillo_timer > 0:
		brillo_timer -= delta
		if brillo_timer <= 0:
			sprite.modulate = Color(1, 1, 0) if seleccionada else Color(1, 1, 1)

func set_datos(a_idx: int, b_idx: int, nuevo_peso: int) -> void:
	nodo_a_idx = a_idx
	nodo_b_idx = b_idx
	peso = nuevo_peso
	if label_peso:
		label_peso.text = str(peso)

func _on_body_entered(body) -> void:
	print("Entroooooooo")
	peso = peso - body.peso
	label_peso.text = str(peso)
	print(peso)


func _on_body_exited(body) -> void:
	peso = peso + body.peso
	label_peso.text = str(peso)
	print(peso)

func set_textura(nueva_textura: Texture2D) -> void:
	sprite.texture = nueva_textura
