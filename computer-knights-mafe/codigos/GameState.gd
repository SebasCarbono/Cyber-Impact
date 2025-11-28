extends Node3D

const RUTA_CORRECTA = [1, 6, 4, 5]
var current_step = 0

func _ready():
	var lab = get_node("laberinto_cuadrado")
	for child in lab.get_children():
		if child is Area3D:
			child.connect("input_event", _on_node_clicked.bind(child))

func _on_node_clicked(child, camera, event, click_pos, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var id = int(child.name.strip_letters())
		check_player_input(id)

func check_player_input(vertex_id: int):
	if vertex_id == RUTA_CORRECTA[current_step]:
		print("Correcto:", vertex_id)
		current_step += 1
		
		if current_step == RUTA_CORRECTA.size():
			print("¡¡Recorrido completado!!")
			reset_game()
	else:
		print("Error, ruta incorrecta")
		reset_game()

func reset_game():
	current_step = 0
	print("Reinicio")
