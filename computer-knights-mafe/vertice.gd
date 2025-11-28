extends Area3D

@export var nombre = ""
var paso = false

# Variables para parpadeo
var parpadeando = false
var tiempo_parpadeo = 0.5
var timer_parpadeo = 0.0
var color_original: Color = Color.WHITE

func _process(delta):
	if parpadeando:
		timer_parpadeo += delta
		if timer_parpadeo >= tiempo_parpadeo:
			_toggle_color_parpadeo()
			timer_parpadeo = 0.0

func _on_body_entered(body: RigidBody3D) -> void:
	if !paso:
		$"../../..".save(nombre)
		paso = true
		print(nombre)
		_cambiar_color_correcto()

# Cambiar el color del nodo actual a verde
func _cambiar_color_correcto():
	for child in get_children():
		_set_color(child, Color(0.1, 1.0, 0.1))  # verde

# Preparar nodo siguiente para parpadeo naranja
func _proximo_parpadeante():
	# Guardar color original
	for child in get_children():
		if child is MeshInstance3D:
			var mat = child.get_active_material(0)
			if mat and mat is StandardMaterial3D:
				color_original = mat.albedo_color
			else:
				color_original = Color.WHITE
		elif child is CSGShape3D:
			color_original = child.material.albedo_color if child.material and child.material is StandardMaterial3D else Color.WHITE

	parpadeando = true
	timer_parpadeo = 0.0

func _toggle_color_parpadeo():
	for child in get_children():
		var current_color = _get_current_color(child)
		var next_color = Color.ORANGE if current_color != Color.ORANGE else color_original
		_set_color(child, next_color)

# Función segura para cambiar color de cualquier material
func _set_color(child, color: Color) -> void:
	if child is MeshInstance3D:
		var mat = child.get_active_material(0)
		if mat and mat is StandardMaterial3D:
			mat.albedo_color = color
		else:
			# Reemplazar cualquier material por StandardMaterial3D
			var new_mat = StandardMaterial3D.new()
			new_mat.albedo_color = color
			child.set_surface_override_material(0, new_mat)
	elif child is CSGShape3D:
		if child.material and child.material is StandardMaterial3D:
			child.material.albedo_color = color
		else:
			var new_mat = StandardMaterial3D.new()
			new_mat.albedo_color = color
			child.material = new_mat

# Función para obtener color actual de manera segura
func _get_current_color(child) -> Color:
	if child is MeshInstance3D:
		var mat = child.get_active_material(0)
		if mat and mat is StandardMaterial3D:
			return mat.albedo_color
	elif child is CSGShape3D and child.material and child.material is StandardMaterial3D:
		return child.material.albedo_color
	return Color.WHITE
