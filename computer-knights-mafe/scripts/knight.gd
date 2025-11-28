extends CharacterBody2D

var _move_speed = 200
var _jump_speed = 500
var gravity = 900
var is_facing_right = true
var att = false

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	move_x()
	flip()
	jump(delta)
	handle_animations()
	move_and_slide()

# 🔹 Movimiento horizontal
func move_x():
	var input_axis = Input.get_axis("left", "right")
	velocity.x = input_axis * _move_speed

# 🔹 Salto
func jump(delta):
	if is_on_floor() and Input.is_action_just_pressed("Jump") and not att:
		velocity.y = -_jump_speed
		animated_sprite.play("Jump")
	if not is_on_floor():
		velocity.y += gravity * delta

# 🔹 Ataque
func _process(delta):
	if Input.is_action_just_pressed("Attack") and not att:
		att = true
		animated_sprite.play("Attack")

# 🔹 Animaciones normales
func handle_animations():
	if att:
		return  # no interrumpir el ataque

	if not is_on_floor():
		animated_sprite.play("Jump")
	elif velocity.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("Idle")

# 🔹 Volteo del sprite
func flip():
	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x < 0
		is_facing_right = velocity.x > 0

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "Attack":
		att = false
		if is_on_floor():
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Idle")
