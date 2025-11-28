extends CharacterBody2D

@export var speed: float = 400.0
@export var bullet_scene: PackedScene = preload("res://Scenes/espada.tscn")


func _physics_process(delta):
	var direction = 0
	if Input.is_action_pressed("left"):
		direction -= 1
	elif Input.is_action_pressed("right"):
		direction += 1

	velocity.x = direction * speed
	move_and_slide()

	if Input.is_action_just_pressed("Attack"):
		shoot()

func shoot():
	var espada = bullet_scene.instantiate()
	get_tree().current_scene.add_child(espada)
	espada.position = position + Vector2(30 , 0)
