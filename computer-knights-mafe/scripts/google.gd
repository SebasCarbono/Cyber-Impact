extends Node2D

# Lista de escenas posibles
var ads = [ preload("res://Scenes/ads.tscn"),
	preload("res://Scenes/ad2.tscn"),
	preload("res://Scenes/ad3.tscn"),
	preload("res://Scenes/ad4.tscn"),
	preload("res://Scenes/ad5.tscn"),
	preload("res://Scenes/ad6.tscn") ]
var spawn_timer: Timer
var link = ""

func _ready():
	await get_tree().process_frame
	link = get_tree().current_scene.scene_file_path
	Global.escena_anterior = link
	$CanvasLayer/Label.visible = false
	randomize()
	$CanvasLayer/Label.text = "Contador: " + str(Global.count)

func _process(delta: float) -> void:
	$CanvasLayer/Label.text = "Contador: " + str(Global.count)

func spawn_object():
	Global.google = true
	if Global.count == 9:
		spawn_timer.stop()
		return
		
	if ads.is_empty():
		return
		
	var random_index = randi() % ads.size()
	var random_scene = ads[random_index]
	var obj = random_scene.instantiate()
	var screen_size = get_viewport_rect().size

	obj.position = Vector2(randf_range(50, screen_size.x - 50), -10)
	add_child(obj)


	if not spawn_timer:
		spawn_timer = Timer.new()
		spawn_timer.wait_time = 0.8
		spawn_timer.one_shot = false
		spawn_timer.timeout.connect(spawn_object)
		add_child(spawn_timer)
	elif spawn_timer.is_stopped() == false:
		return
		
	spawn_timer.start()
	

func _on_piso_area_entered(area: Area2D) -> void:
	if area.name == "ads":
		Global.count -= 1
	

func _on_button_pressed() -> void:
	if Global.google:
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file(Global.caminoEquivocado)

	if not spawn_timer:
		spawn_timer = Timer.new()
		spawn_timer.wait_time = 0.8
		spawn_timer.one_shot = false
		spawn_timer.timeout.connect(spawn_object)
		add_child(spawn_timer)
	elif spawn_timer.is_stopped() == false:
		return  
		
	spawn_timer.start()
	

func _on_button_2_pressed() -> void:
	Global.camino_equivocado()
	
