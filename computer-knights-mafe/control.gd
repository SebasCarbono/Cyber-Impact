extends Control

@onready var terminal: RichTextLabel = $Panel/Terminal
@onready var hidden_input: LineEdit = $HiddenLineEdit

var lines: Array = []
var prompt := "mafe@godot:~$ "
var current_input := ""

var cursor_visible := true
var cursor_timer: Timer

var awaiting_algorithm_choice := false
var intro_finished := false

# Escenas
@export var bfs_scene: PackedScene
@export var dfs_scene: PackedScene


func _ready():
	terminal.bbcode_enabled = true
	terminal.clear()

	hidden_input.visible = false
	hidden_input.grab_focus()

	_cursor_init()

	# Iniciar mega intro glitcheada
	await _intro_glitch_sequence()

	_intro_text_final()

	awaiting_algorithm_choice = true
	intro_finished = true

	_show_prompt()


# -----------------------------------------
# CURSOR
# -----------------------------------------
func _cursor_init():
	cursor_timer = Timer.new()
	cursor_timer.wait_time = 0.5
	cursor_timer.one_shot = false
	add_child(cursor_timer)
	cursor_timer.timeout.connect(_on_cursor_timer)
	cursor_timer.start()


func _on_cursor_timer():
	cursor_visible = !cursor_visible
	_update_display()


# ======================================================
# 🎭  MEGA INTRO GLITCHEADA (CON EFECTOS MÁS POTENTES)
# ======================================================
func _intro_glitch_sequence():

	var glitch_chunks = [
		"S#%T&MA COR>R^P>-[D0 DET3CTAD0...",
		"## ERR--0R EN/EL/NUCLEO/##",
		"PROT0C0l0...F@ll@do.",
		"D@T@S CORR%MP!DOS...",
		"CARGAND0 --- F@LLO",
		"Re-e-e-estab-le-ci-end-o s-sis-te-ma...",
	]

	# Efecto inicial tipo encendido corrupto
	for i in range(4):
		_append_line("[color=black].[/color]")
		await get_tree().create_timer(0.1).timeout

	# Bloque 1: glitch lineal con escritura letra a letra
	for text in glitch_chunks:
		await _type_glitch_line(text)
		await get_tree().create_timer(randf_range(0.1, 0.25)).timeout

	# Bloque 2: explosión de caracteres aleatorios
	for i in range(6):
		var garbage = _random_garbage(20 + randi() % 20)
		_append_line("[color=red]" + garbage + "[/color]")
		await get_tree().create_timer(0.08).timeout

	# Bloque 3: “apagón” breve
	for i in range(3):
		_append_line("")
		await get_tree().create_timer(0.05).timeout


# -------------------------
# EFECTO: escribir texto corrupto lentamente
# -------------------------
func _type_glitch_line(text: String):
	var corrupted := ""
	for c in text:
		if randf() < 0.25:
			corrupted += char(randi() % 94 + 33) # ASCII random visible
		else:
			corrupted += c

		_append_line("[color=red]" + corrupted + "[/color]")
		await get_tree().create_timer(0.02).timeout

	# Agregar la línea final ya completa
	_append_line("[color=red]" + text + "[/color]")


# -------------------------
# Texto basura aleatorio
# -------------------------
func _random_garbage(length: int) -> String:
	var chars = "!#$%&/()=?¡*{}[]+-.,;<>"
	var out := ""
	for i in range(length):
		out += chars[randi() % chars.length()]
	return out


# ======================================================
# INTRO FINAL (NORMAL)
# ======================================================
func _intro_text_final():
	_append_line("\n[b]SISTEMA CORROMPIDO DETECTADO[/b]")
	_append_line("Para acceder al computador infectado debes cruzar el Laberinto de Comandos.")
	_append_line("Elige una ruta:")
	_append_line("  • [color=yellow]bfs[/color] — amplitud")
	_append_line("  • [color=yellow]dfs[/color] — profundidad\n")
	_append_line("Escribe tu elección para continuar...")


# ======================================================
# INPUT LUEGO DE LA INTRO
# ======================================================
func _input(event):
	if not intro_finished:
		return

	if event is InputEventKey and event.pressed:

		if event.keycode in [KEY_ENTER, KEY_KP_ENTER]:
			_process_enter()
			return

		if event.keycode == KEY_BACKSPACE:
			if current_input.length() > 0:
				current_input = current_input.left(current_input.length() - 1)
				_update_display()
			return

		if event.unicode == 0:
			return

		var ch := char(event.unicode)
		if ch != "":
			current_input += ch
			_update_display()


func _process_enter():
	var cmd := current_input.strip_edges()
	_append_line(prompt + cmd)

	if awaiting_algorithm_choice:
		_handle_choice(cmd)
	else:
		_append_line("Comando no válido en este modo.")

	current_input = ""
	_show_prompt()


# ======================================================
# ELECCIÓN BFS / DFS
# ======================================================
func _handle_choice(cmd: String):
	match cmd.to_lower():
		"bfs":
			_append_line("[color=green]Ruta BFS seleccionada.[/color]")
			Global.desicion = "BFS"
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://escenas/Escena_principal.tscn")


		"dfs":
			Global.desicion = "DFS"
			_append_line("[color=green]Ruta DFS seleccionada.[/color]")
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://escenas/Escena_principal.tscn")

		_:
			_append_line("[color=red]Entrada inválida.[/color] Escribe bfs o dfs.")


# ======================================================
# DISPLAY / SCROLL
# ======================================================
func _show_prompt():
	_update_display()


func _append_line(text: String):
	lines.append(text)
	_update_display()


func _update_display():
	terminal.clear()

	for l in lines:
		terminal.append_text(l + "\n")

	var cursor_char := "_" if cursor_visible else " "
	terminal.append_text(prompt + current_input + cursor_char)

	var bar = terminal.get_v_scroll_bar()
	if bar:
		bar.value = bar.max_value
