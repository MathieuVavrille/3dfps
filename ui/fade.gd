extends Control

signal faded_in
signal faded_out

var fade_in = false
var fade_out = false
var FADE_TIME = 1.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade_in:
		modulate.a = move_toward(modulate.a, 1., delta / FADE_TIME)
		if modulate.a  == 1.:
			fade_in = false
			faded_in.emit()
	if fade_out:
		modulate.a = move_toward(modulate.a, 0., delta / FADE_TIME)
		if modulate.a == 0.:
			fade_out = false
			faded_out.emit()

func start_fade_in(fade_time):
	modulate.a = 0
	fade_in = true
	FADE_TIME = fade_time
func start_fade_out(fade_time):
	modulate.a = 1.0
	fade_out = true
	FADE_TIME = fade_time
