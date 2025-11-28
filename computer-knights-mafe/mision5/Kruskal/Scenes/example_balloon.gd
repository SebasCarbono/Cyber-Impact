class_name DialogueInfoBalloon
extends CanvasLayer

@onready var balloon: Control = %Balloon
@onready var dialogue_label: RichTextLabel = %DialogueLabel
@onready var progress: Polygon2D = %Progress

var messages: Array = []
var index := 0
var is_showing := false

func _ready() -> void:
	balloon.hide()
	progress.hide()
	balloon.gui_input.connect(_on_balloon_gui_input)

func show_messages(texts: Array) -> void:
	if texts.is_empty():
		return
	messages = texts
	index = 0
	balloon.show()
	_show_current_message()

func _show_current_message() -> void:
	is_showing = true
	progress.hide()
	dialogue_label.modulate.a = 0.0
	dialogue_label.text = messages[index]
	_play_fade_in()

func _play_fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(dialogue_label, "modulate:a", 1.0, 0.4)
	tween.finished.connect(func ():
		progress.show()
		is_showing = false
	)

func _next_message() -> void:
	index += 1
	if index < messages.size():
		_show_current_message()
	else:
		balloon.hide()

func _on_balloon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and not is_showing:
		_next_message()
	elif event.is_action_pressed("ui_accept") and not is_showing:
		_next_message()
