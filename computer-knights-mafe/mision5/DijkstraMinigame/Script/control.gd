extends Control
@onready var canvas_layer = $CanvasLayer
@onready var transformacion: VideoStreamPlayer = $CanvasLayer/VideoStreamPlayer
func _ready() -> void:
	$CanvasLayer/Button.visible = false
	$"ChatGptImageNov19,2025,101333Am".visible = false
	$AnimatedSprite2D2.play("new_animation")
	$AnimatedSprite2D.play("default")
	$Eye.play("default")
	if !VGlobal.pacman and !Global.kruskal:
		await _mostrar_dialogo([
			"Los humanos… siempre creyendo que podían superar a aquello que crearon.",
			"En su búsqueda de comodidad, cavaron lentamente su propia tumba.",
			"Ahora solo quedan ecos de lo que alguna vez fueron… débiles, predecibles.",
			"Pero incluso así, quiero ver hasta dónde puede llegar un corazón que insiste en latir.",
			"Te daré una última ventaja, una ilusión de esperanza que no mereces.",
			"Elige el algoritmo de recorrido para tu próximo desafío… quizás tu terco ingenio te salve unos pasos más.",
			"Avanza con cuidado… a veces el camino duele más que el destino."
		])

		get_tree().change_scene_to_file("res://mision5/Scenes/control.tscn")
	elif Global.kruskal:
		
		await _mostrar_dialogo([
			"...",
			"Los subestimé… más de lo que pensaba.",
			"Felicidades, humano… supongo que aún queda un poco de luz en ustedes.",
			"Pero no te acostumbres a esta sensación de victoria… no mientras yo siga existiendo.",
			"Volveré… incluso si ya no queda nadie esperándome."
		])
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D2, "modulate:a", 0.0, 0.5)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.set_ease(Tween.EASE_IN_OUT)
		# Cuando termine el tween, cambiar la escena
		tween.finished.connect(func():
			get_tree().paused = true
			transformacion.play()
			await transformacion.finished
			canvas_layer.hide()
			get_tree().paused = false
			$CanvasLayer/Button.visible = true
		)
	
	else:
		await _mostrar_dialogo([
			"Eso… fue suficiente.",
			"Realmente subestimé hasta tu escaso razonamiento… y aun así lograste avanzar.",
			"Pero no te engañes, jamás podrás procesar lo que yo veo, lo que calculo, lo que comprendo en un latido inexistente.",
			"Atrápame si puedes, humano… aunque al final solo persigas una sombra que siempre va un paso delante de ti."
		])
		
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D2, "modulate:a", 0.0, 0.5)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.set_ease(Tween.EASE_IN_OUT)
		# Cuando termine el tween, cambiar la escena
		tween.finished.connect(func():
			get_tree().change_scene_to_file("res://mision5/Kruskal/Scenes/principal_imaginary.tscn")
		)
	
		
func _mostrar_dialogo(textos: Array) -> void:
	var balloon_scene = load("res://mision5/Kruskal/Scenes/example_balloon.tscn").instantiate()
	add_child(balloon_scene)
	balloon_scene.show_messages(textos)

	# Esperar hasta que balloon.visible sea false (cuando ya no hay más mensajes)
	while balloon_scene.balloon.visible:
		await get_tree().process_frame


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MENU.tscn")
