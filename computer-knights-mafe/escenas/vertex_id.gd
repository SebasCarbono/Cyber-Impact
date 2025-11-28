extends Area3D

@export var vertex_id := 0

func _ready():
	Area3D = true

func Area3D(camera, event, pos, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_node("/root/GameState").check_player_input(vertex_id)
