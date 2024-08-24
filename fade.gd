extends Control

signal faded_in
signal faded_out

var fade_in = false
var fade_out = false
var fade_time = 1.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade_in:
		modulate.a = move_toward(modulate.a, 1., delta / fade_time)
		if modulate.a  == 1.:
			fade_in = false
			faded_in.emit()
	if fade_out:
		modulate.a = move_toward(modulate.a, 0., delta / fade_time)
		if modulate.a == 0.:
			fade_out = false
			faded_out.emit()

func start_fade_in(fade_time):
	modulate.a = 0
	fade_in = true
func start_fade_out(fade_time):
	modulate.a = 1.0
	fade_out = true
