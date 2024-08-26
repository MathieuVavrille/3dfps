extends Control

var is_on_screen = false
var fade_time = 0.5

func _ready():
	modulate.a = 0.

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if is_on_screen:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		is_on_screen = not is_on_screen
	if is_on_screen:
		modulate.a = move_toward(modulate.a, 0.95, delta / fade_time)
	else:
		modulate.a = move_toward(modulate.a, 0., delta / fade_time)

