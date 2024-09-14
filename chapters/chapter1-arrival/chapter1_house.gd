extends Node3D

var fade_times = 2.

func _ready():
	$Fogs.visible=false
	for fog in $Fogs.get_children():
		fog.disable(true)
	for fish in $Fish.get_children():
		fish.collected.connect(fish_collected)
	$Fade.start_fade_out(fade_times)


func fish_collected():
	$ObjectivesChapter1.objective_got("fish")

func _on_objectives_can_sleep():
	$Fogs.visible=true
	for fog in $Fogs.get_children():
		fog.disable(false)

func end_chapter():
	$Fade.start_fade_in(2)

func _on_color_rect_faded_in():
	var timer = get_tree().create_timer(fade_times)
	timer.timeout.connect(change_chapter)
var next_scene = preload("res://chapters/chapter2-exploration/chapter2.tscn")
func change_chapter():
	get_tree().root.add_child(next_scene.instantiate())
	get_node("/root/Chapter1House").queue_free()
