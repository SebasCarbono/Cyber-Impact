extends Control


func _ready() -> void:
	print("EscenaAnt - CaminoEq: ", Global.escena_anterior)
	await get_tree().create_timer(1.0).timeout
	if Global.escena_anterior == "":
		print(" 333 EscenaAnt - CaminoEq: ", Global.escena_anterior)
		var raiz = Global.raiz
		print("Raiz: ", raiz)
		var link_raiz = raiz.link
		print("LinkRaiz: ", link_raiz)
		get_tree().change_scene_to_file(link_raiz)
	else:
		print("222 - EscenaAnt - CaminoEq: ", Global.escena_anterior)
		GlobalTree.volver_padre(Global.escena_anterior)
