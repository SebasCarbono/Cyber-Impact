extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	

func _on_izq_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	GlobalTree.ir_izq(Global.escena_anterior)

func _on_der_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	GlobalTree.ir_der(Global.escena_anterior)
	

func _on_izq_mouse_entered() -> void:
	$AnimatedSprite2D.flip_h = true
	

func _on_der_mouse_entered() -> void:
	$AnimatedSprite2D.flip_h = false
	
