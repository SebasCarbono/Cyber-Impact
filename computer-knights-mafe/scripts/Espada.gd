extends Area2D

@export var speed: float = 600.0

func _physics_process(delta):
	monitoring = true
	position.y += speed * delta*-1 
	if position.y < -350:
		queue_free()
