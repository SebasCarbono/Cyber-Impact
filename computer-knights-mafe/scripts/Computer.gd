extends Node2D

var link = ""
@onready var label = $Label
@onready var transformacion: VideoStreamPlayer = $CanvasLayer/transformacion

func _ready() -> void:
	await get_tree().process_frame
	link = get_tree().current_scene.scene_file_path
	Global.añadirCompletado(link)
	

@warning_ignore("unused_parameter")
func _on_area_2d_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(0.1).timeout
	GlobalTree.ir_izq(link)

@warning_ignore("unused_parameter")
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(0.1).timeout
	GlobalTree.ir_der(link)
