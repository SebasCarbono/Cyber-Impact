extends RichTextLabel

signal textbox_closed
var speed = 0.08
var link = ""
var textos = [
	"Mira a quien tenemos aquí...",
	"No te voy a dejar pasar tan facil caballerito "
]
var power_growing = false
var power_speed = 2.0 
var escribiendo := false
@onready var inbox: Node2D = $".."

func _ready():
	#await get_tree().process_frame
	inbox.visible = false
	link = get_tree().current_scene.scene_file_path
	Global.escena_anterior = link
	print("Link 1: ", link)
	if Global.escenaCompletada.has(link):
		get_tree().change_scene_to_file("res://Scenes/seleccion2.tscn")
		return
	inbox.visible = true
	if not Global.texto_mostrado:
		$"../Mails".visible = false
		$"../Power".visible = false
		$"../AnimatedSprite2D".play("idle")
		bbcode_enabled = true
		clear()
		await mostrar_textos()
		Global.texto_mostrado = true
	elif Global.texto_mostrado and Global.perdio:
		$"../Mails".visible = false
		$"../Power".visible = false
		$"../AnimatedSprite2D".play("idle")
		bbcode_enabled = true
		textos.clear()
		textos = ["JAJAJAJA", "Has caído como un ingenuo.", "Tendrás otra oportunidad para que no te sientas mal."]
		await mostrar_textos()
	else:
		$"../Mails".visible = false
		$"../Power".visible = false
		$"../AnimatedSprite2D".play("Hurt")
		textos.clear()
		textos = ["NOOOOO", "No has caído en mi trampa.", "Te has salvado del fishing caballero."]
		Global.añadirCompletado(link)
		mostrar_textos()

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
		
	if !Global.texto_mostrado:
		$"../AnimatedSprite2D".play("attack")
		$"../Power".visible = true
		$"../Power".play("default")
	elif Global.texto_mostrado and Global.perdio:
		$"../AnimatedSprite2D".play("attack")
		$"../Power".visible = true
		$"../Power".play("default")
	else:
		$"../AnimatedSprite2D".play("death")
		print("Link 2: ", link, " Global.escena... : ", Global.escena_anterior)
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/seleccion2.tscn")

func _on_power_animation_finished() -> void:
	$"../Mails".visible = true
