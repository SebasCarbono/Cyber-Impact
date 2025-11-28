extends CharacterBody2D

@export var peso = randi_range(1,5)
@export var speed: float = 150.0
var path: Array = []
var current_index := 0

func _physics_process(delta):
	if path.is_empty():
		return
	
	$Label.text = str(peso)
	
	var target = path[current_index]
	var direction = (target - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	# Llega al punto
	if global_position.distance_to(target) <= speed * delta + 2:
		current_index += 1
		if current_index >= path.size():
			velocity = Vector2.ZERO
			queue_free()
			get_tree().change_scene_to_file("res://mision5/Scenes/game_over.tscn")
			return
			
func set_path(new_path: Array):
	if new_path.is_empty():
		return
	
	# Invertir el array
	var reversed_path = new_path.duplicate()
	reversed_path.reverse()
	
	path = reversed_path
	current_index = 0

func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("heroe"):
		if body.peso < peso:
			peso -= body.peso
			Global.peso_total -= body.peso 
			body.queue_free()
		else:
			print("Lose")
			Global.peso_total = Global.peso_total - body.peso - peso
			body.queue_free()
			Global.daño += 1
			print(Global.daño)
			queue_free()
