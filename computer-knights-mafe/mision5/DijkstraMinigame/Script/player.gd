extends CharacterBody2D

const GRAVITY: int = 1800
const MAX_VEL: int = 300
const FLAP_SPEED: int = -350
const START_POS = Vector2(100, 400)

var flying: bool = false
var falling: bool = false

func _ready():
	reset()

func reset():
	falling = false
	flying = false
	set_rotation(0)
	velocity = Vector2.ZERO
	#position = START_POS

func _process(delta: float):
	if flying:
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if not flying:
				flying = true  # activa el vuelo al primer clic
			flap()

func _physics_process(delta: float):
	if flying or falling:
		# Mueve horizontalmente
		velocity.x = Global.Speed_x 

		# Gravedad vertical
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL

		# Rotación según velocidad
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
		elif falling:
			set_rotation(PI / 2)

		move_and_slide()  # Godot 4 usa la propiedad integrada

func flap():
	velocity.y = FLAP_SPEED
	
var glitch_active := false
var saved_velocity := Vector2.ZERO

func aplicar_glitch():
	if glitch_active:
		return
	glitch_active = true

	var tipo = randi() % 3

	# Apagar física, movimiento y rotación
	set_physics_process(false)
	set_process(false)

	match tipo:
		# Teleport
		0:
			await get_tree().create_timer(0.12).timeout
			position += Vector2(randf_range(-90, 90), randf_range(-50, 50))

		# Lag
		1:
			await get_tree().create_timer(0.20).timeout
			position += Vector2(randf_range(-20, 20), randf_range(-8, 8))

		# Errático
		2:
			var offset = Vector2(randf_range(-25, 25), randf_range(-25, 25))
			var tween = create_tween()
			tween.tween_property(self, "position", position + offset, 0.1)
			tween.tween_property(self, "position", position - offset * 0.5, 0.1)
			await tween.finished

	# Restaurar movimiento
	set_physics_process(true)
	set_process(true)

	glitch_active = false
