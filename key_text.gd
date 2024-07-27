extends Control

var FADING_TIME = 0.5
var make_hidden = true


func _process(delta):
	if make_hidden:
		modulate.a = move_toward(modulate.a, 0, delta / FADING_TIME)
	else:
		modulate.a = move_toward(modulate.a, 1, delta / FADING_TIME)

func fade_out():
	make_hidden = true

func show_text(text):
	$Text.text = text
	make_hidden = false
