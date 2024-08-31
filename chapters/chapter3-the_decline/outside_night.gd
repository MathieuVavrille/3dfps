extends Node3D

var fade_times = 2.
var next_scene = preload("res://chapters/chapter3-the_decline/vet.tscn")

func _ready():
	$Fade.start_fade_out(fade_times)
	var timer = get_tree().create_timer(5)#24)
	timer.timeout.connect(end_sub_chapter)

func end_sub_chapter():
	$Fade.start_fade_in(fade_times)

func _on_fade_faded_in():
	var timer = get_tree().create_timer(1)
	timer.timeout.connect(go_to_next_scene)

func go_to_next_scene():
	get_tree().root.add_child(next_scene.instantiate())
	get_node("/root/OutsideNight").queue_free()
