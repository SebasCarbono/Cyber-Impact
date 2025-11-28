extends RichTextLabel

signal textbox_closed
var speed = 0.05
var textos = [
	"Nemi: parece que la simulación te ha tranformado en...",
	"Nemi: ¿Un caballero?",
	"Nemi: Mmmm..., realmente no tiene importancia.",
	"Nemi: ¡Lo importante es que has logrado entrar!",
	"Nemi: Escoge el camino que quieras.",
	"Nemi: Apenas entres, escanearé el código interno de la simulación y te daré intrucciones.",
	"Nemi: Suerte, caballero"
	]
var power_growing = false
var power_speed = 2.0 
var escribiendo := false
@onready var transformacion: VideoStreamPlayer = $"../CanvasLayer/transformacion"
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var static_body_2d: StaticBody2D = $"../StaticBody2D"

func _ready():
	
	get_tree().paused = true
	transformacion.play()
	await transformacion.finished
	canvas_layer.hide()
	get_tree().paused = false
	
	if not Global.texto_mostradoC:
		bbcode_enabled = true
		clear()
		await mostrar_textos()
		Global.texto_mostradoC = true
	else:
		$"../text".visible = false
		$".".visible = false

func _input(_event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if escribiendo:
			escribiendo = false
		else:
			emit_signal("textbox_closed")

func mostrar_textos() -> void:
	for t in textos:
		text = ""
		escribiendo = true
		var i := 0
		while i < t.length():
			if not escribiendo:
				text = t
				break
			text += t[i]
			i += 1
			if get_tree() != null:
				await get_tree().create_timer(speed).timeout
			else:
				break
		escribiendo = false
		await self.textbox_closed
	
	if is_inside_tree():
		$"../text".visible = false
		$".".visible = false
		
	
