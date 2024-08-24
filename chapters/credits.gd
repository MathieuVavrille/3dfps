extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var fadein = false
var FADEIN_TIME = 8.
func _process(delta):
	if fadein:
		$FallFade.modulate.a = move_toward($FallFade.modulate.a, 1., delta / FADEIN_TIME)
		$Background.modulate.a = move_toward($Background.modulate.a, 1., delta / FADEIN_TIME)

func start():
	print("here")
	$Music.play()
	var timer = get_tree().create_timer(10.16)
	timer.timeout.connect(start_text)
	fadein = true
	
func start_text():
	$Label.visible = true
