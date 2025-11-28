extends Node2D

@onready var sprite = $Portal/AnimatedSprite2D

func _ready():
	$AnimatedSprite2D.visible = false
	$Player.aplicar_glitch()
	$Parallax2D/AnimatedSprite2D.play("default")
	$Player.flying = true
	$"Parallax2D/✨".play("default")
	latido()
	
var glitch_timer := 0.0

func _process(delta):
	if Engine.is_editor_hint(): return # por si editas en tiempo real

	glitch_timer -= delta
	if glitch_timer <= 0:
		glitch_global()
		glitch_timer = randf_range(1.0, 3.0)  # cada glitch ocurre entre 1 y 3 segundos

		
func latido():
	var tween = create_tween()
	tween.set_loops() 

	# Más pequeño: 0.85 ↔ 1.0
	tween.tween_property(sprite, "scale", Vector2(0.85, 0.85), 0.35).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "scale", Vector2(0.65, 0.65), 0.35).set_trans(Tween.TRANS_SINE)

func aplicar_glitch():
	var tipo = randi() % 3
	
	match tipo:
		0:
			# Teletransporte corto
			position += Vector2(randf_range(-60, 60), randf_range(-60, 60))

		1:
			# Congelarlo un instante (tipo lag)
			set_physics_process(false)
			await get_tree().create_timer(0.12).timeout
			set_physics_process(true)

		2:
			# Micro-temblor/errático rápido
			var offset = Vector2(randf_range(-20, 20), randf_range(-20, 20))
			var tween = create_tween()
			tween.tween_property(self, "position", position + offset, 0.1)
			tween.tween_property(self, "position", position - offset, 0.1)

func glitch_global():
	# Pausa todo el juego
	get_tree().paused = true

	# (Opcional) teletransportar ligeramente al player mientras está congelado
	# Esto se verá cuando se despausa
	if $Player:
		$Player.position += Vector2(randf_range(-80, 80), randf_range(-40, 40))

	# (Opcional) mover un poco la cámara o parallax para que el efecto sea más fuerte
	if has_node("Camera2D"):
		$Camera2D.offset = Vector2(randf_range(-20, 20), randf_range(-20, 20))

	# Tiempo del glitch congelado
	await get_tree().create_timer(0.18, true).timeout

	# Restaurar
	if has_node("Camera2D"):
		$Camera2D.offset = Vector2.ZERO

	get_tree().paused = false

func _on_portal_body_entered(body: CharacterBody2D) -> void:
	$Parallax2D.scroll_offset = Vector2.ZERO  # detiene solo este layer
	$"CanvasLayer/20".visible = false
	$CanvasLayer/Sprite2D.visible = false
	$CanvasLayer/Red.visible = false
	$Player.queue_free()
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("default")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	get_tree().change_scene_to_file("res://mision5/Kruskal/Scenes/principal_imaginary.tscn")
