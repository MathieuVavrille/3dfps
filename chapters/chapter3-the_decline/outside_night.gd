extends Node3D

var fade_times = 2.

func _ready():
	$Fade.start_fade_out(fade_times)
	var timer = get_tree().create_timer(30)
	timer.timeout.connect(end_sub_chapter)

func end_sub_chapter():
	$Fade.start_fade_in(fade_times)

func _on_fade_faded_in():
	var timer = get_tree().create_timer(0.5)
	timer.timeout.connect(get_tree().quit)
