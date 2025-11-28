extends Camera2D

@onready var player = get_node("../Player") # ruta al jugador

func _ready():
	pass

func _process(delta):
	if player:
		global_position.x = player.global_position.x + 100 # offset opcional
		global_position.y = 350 # fija la altura de la cámara
