extends TextEdit

@export var full_text: String = "Game over..."
@export var char_delay: float = 0.2 

@onready var boton1: Button = $"../Restart"
@onready var boton2: Button = $"../Exit"
var ya = false
var _current_index: int = 0
var _timer: Timer

func _ready():
	Global.gameOver = true
	$"../AnimatedSprite2D".play("new_animation")
	_timer = Timer.new()
	_timer.wait_time = char_delay
	_timer.one_shot = false
	_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(_timer)
	text = ""
	_timer.start()
	_hide_buttons()

func _hide_buttons():
	boton1.visible = false
	boton1.modulate.a = 0.0
	boton2.visible = false
	boton2.modulate.a = 0.0

func _on_timer_timeout():
	if _current_index < full_text.length():
		text += full_text[_current_index]
		_current_index += 1
	else:
		if ya:
			_timer.stop()
			_show_buttons_sequence()

func _show_buttons_sequence():
	await get_tree().create_timer(1.0).timeout
	boton1.visible = true
	var tween1 = create_tween()
	tween1.tween_property(boton1, "modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE)

	tween1.tween_callback(func():
		boton2.visible = true
		var tween2 = create_tween()
		tween2.tween_property(boton2, "modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE)
	)


func _on_restart_pressed() -> void:
	Global.game_over_mostrado = true
	get_tree().change_scene_to_file("res://mision5/Kruskal/Scenes/principal_imaginary.tscn")
	



func _on_exit_pressed() -> void:
	Global.kruskal = false
	get_tree().change_scene_to_file("res://mision5/DijkstraMinigame/scene/control.tscn")



func _on_animated_sprite_2d_animation_finished() -> void:
	_timer.start()
	ya = true
