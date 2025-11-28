extends RigidBody3D

@export var velocidad : float = 10.0
@export var suavizado : float = 5.0

func _physics_process(delta):
	var escena = get_tree().get_nodes_in_group("Escena_principal")[0]

	if not escena.muerto:
		var dir = Vector3.ZERO

		# Movimiento con teclado o touch
		if Input.is_action_pressed("d") or Input.is_action_pressed("touch_derecha"):
			dir.x += 1
		if Input.is_action_pressed("a") or Input.is_action_pressed("touch_izquierda"):
			dir.x -= 1
		if Input.is_action_pressed("w") or Input.is_action_pressed("touch_arriba"):
			dir.z -= 1
		if Input.is_action_pressed("s") or Input.is_action_pressed("touch_abajo"):
			dir.z += 1

		# Aplicar velocidad
		dir = dir.normalized() * velocidad
		linear_velocity.x = dir.x
		linear_velocity.z = dir.z

		# Suavizar cuando no se presiona ninguna tecla
		if dir == Vector3.ZERO:
			linear_velocity.x = lerp(linear_velocity.x, 0.0, suavizado * delta)
			linear_velocity.z = lerp(linear_velocity.z, 0.0, suavizado * delta)
	
	
