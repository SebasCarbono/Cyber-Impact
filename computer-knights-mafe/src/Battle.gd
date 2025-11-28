extends Control

signal textbox_closed

@export var enemy: Resource = null

var link = ""
var current_enemy_health = 0
var is_defending = false
var preguntas = ["Cuando un virus como YO aparece\n¿Es seguro seguir conectado a la red?",
"¿Deberías usar el computador\nmientras YO estoy aquí?", "¿Por qué no apagas tu AntiVirus?",
"¿No quisieras conectar\nalguna memoria externa?"]

func _ready():
	await get_tree().process_frame
	link = get_tree().current_scene.scene_file_path
	Global.escena_anterior = link
	
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	$EnemyContainer/Enemy.texture = enemy.texture
	current_enemy_health = enemy.health
	
	$Textbox.hide()
	$ActionsPanel.hide()
	
	display_text("¡Un virus infeccisoso ha aparecido\nen forma de %s!" % enemy.name.to_upper())
	await self.textbox_closed
	display_text("Te tengo una pregunta caballero...")
	await self.textbox_closed
	display_question()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]

func _input(_event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		emit_signal("textbox_closed")

func display_text(text):
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Label.text = text

func display_question():
	if preguntas.is_empty():
		display_text("Ya no tengo más preguntas para tí\nMe iré...")
		display_text("El %s se ha marchado por su propia cuenta!\nEsto nunca pasa en la vida real..." % enemy.name)
		await self.textbox_closed
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		if preguntas.is_empty():
			get_tree().change_scene_to_file("res://Scenes/seleccion.tscn")
		
		
	else:
		var seleccion = preguntas.pick_random()
		preguntas.erase(seleccion)
		display_text(seleccion)
		await self.textbox_closed
		$ActionsPanel.show()

func _on_Attack_pressed():
	display_text("¡JAJAJA! Si sigues pensando así\nACABARÉ CON TODO")
	await self.textbox_closed
	display_text("El %s\nintenta destruir ARCHIVOS VITALES!!" % enemy.name)
	await self.textbox_closed
	$AnimationPlayer.play("shake")
	await $AnimationPlayer.animation_finished
	display_text("Te daré otra oportunidad...")
	await self.textbox_closed
	display_question()

func _on_Defend_pressed():
	#var timer = get_tree().create_timer(2.5)  # 5 segundos
	is_defending = true
	
	display_text("¡Tu respuesta es CORRECTA!")
	await self.textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	if current_enemy_health == 0:
		display_text("¡El %s fue derrotado!" % enemy.name)
		await self.textbox_closed
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		#timer.timeout
		get_tree().change_scene_to_file("res://Scenes/seleccion2.tscn")
	
	else:
		await self.textbox_closed
		display_text("¡JAJAJA! ¿Te crees muy listo?\nAquí te va otra pregunta...")
		display_question()
	#timer
