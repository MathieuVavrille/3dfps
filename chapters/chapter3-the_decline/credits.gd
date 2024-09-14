extends Control

var fadein = false
var FADEIN_TIME = 8.
func _process(delta):
	if fadein:
		$FallFade.modulate.a = move_toward($FallFade.modulate.a, 1., delta / FADEIN_TIME)
		$Background.modulate.a = move_toward($Background.modulate.a, 1., delta / FADEIN_TIME)

var start_time = 10.16
var description_time = 15.5
var dev_time = 20.58
var composer_time = 23.05
var thank_time = 25.642

func start():
	$Music.play()
	get_tree().create_timer(start_time).timeout.connect(func(): $TheEnd.visible=true)
	get_tree().create_timer(description_time).timeout.connect(func(): $Description.visible=true)
	get_tree().create_timer(dev_time).timeout.connect(func(): $Creator.visible=true)
	get_tree().create_timer(composer_time).timeout.connect(func(): $Composer.visible=true)
	get_tree().create_timer(thank_time).timeout.connect(func(): $Thank.visible=true)
	fadein = true
