extends Control

var fadein = false
var FADEIN_TIME = 8.
func _process(delta):
	if fadein:
		$FallFade.modulate.a = move_toward($FallFade.modulate.a, 1., delta / FADEIN_TIME)
		$Background.modulate.a = move_toward($Background.modulate.a, 1., delta / FADEIN_TIME)

func start():
	$Music.play()
	var timer = get_tree().create_timer(10.16)
	timer.timeout.connect(start_text)
	fadein = true
	
func start_text():
	$Label.visible = true
