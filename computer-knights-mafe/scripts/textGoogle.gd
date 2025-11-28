extends RichTextLabel

var speed = 0.08
var textos = []
var power_growing = false
var power_speed = 2.0 
var final_text_shown = false  # ← bandera de control

func _ready():
	if Global.google:
		return
	
	textos = [
		"Estamos en navegación",
		"Con la tecla X puedes lanzar espadas y evitar que los anuncios engañosos contaminen el computador!.",
		"¡Estás listo para vencer los anuncios y llegar a los 10 puntos!"
	]
	
	$"../Button".visible = false
	bbcode_enabled = true
	await mostrar_textos()
		
func _process(delta):
	if Global.count >= 10 and not final_text_shown:
		final_text_shown = true 
		$".".visible = true
		$"../text".visible = true
		$"../Label".visible = false
		textos.clear()
		textos = ["¡Lo has logrado, caballero!", "Puedes avanzar..."]
		await mostrar_textos()

func mostrar_textos() -> void:
	for t in textos:
		text = ""
		for char in t:
			text += char
			await get_tree().create_timer(speed).timeout
		await get_tree().create_timer(1.0).timeout
	$"../Button".visible = true
	
func _on_button_pressed() -> void:
	$"../Label".visible = true
	$"../text".visible = false
	$".".visible = false
	Global.googleya = true
	$"../Button".visible = false
	
