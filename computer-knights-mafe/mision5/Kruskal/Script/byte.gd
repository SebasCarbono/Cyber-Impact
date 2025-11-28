extends CharacterBody2D

@export var peso : int
@export var speed: float = 150.0
var path: Array = []
var current_index := 0


func _physics_process(delta):
	if path.is_empty():
		return

	# ✔️ Validaciones de seguridad
	if current_index < 0 or current_index >= path.size():
		path.clear()
		queue_free()
		return

	var target = path[current_index]

	# ✔️ Asegurar que sea Vector2
	if typeof(target) != TYPE_VECTOR2:
		path.clear()
		queue_free()
		return

	# ✔️ Movimiento normal
	var direction = (target - position).normalized()
	velocity = direction * speed
	move_and_slide()

	# ✔️ Llegó al punto
	if position.distance_to(target) < 5:
		current_index += 1
		if current_index >= path.size():
			path.clear()
			queue_free()
			velocity = Vector2.ZERO

func set_path(new_path: Array):
	if new_path.is_empty():
		return

	path = new_path.duplicate()
	current_index = 0
