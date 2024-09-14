extends Node3D

var fade_times = 2.

func _ready():
	print($Player.position)
	$Player/RotationHelper/Camera.make_current()
	$Fogs.visible=false
	for fog in $Fogs.get_children():
		fog.disable(true)
	for child in $Fish.get_children():
		child.collected.connect(fish_collected)
	$ChapterScreen/Chapter.start_fade_in(1.)

func _on_chapter_faded_in():
	get_tree().create_timer(2).timeout.connect(start_chapter)

func start_chapter():
	$ChapterScreen.start_fade_out(fade_times)
	$ChapterScreen/Chapter.start_fade_out(fade_times/2.)

func fish_collected():
	$Objectives2.objective_got("fish")

func _on_objectives_template_can_sleep():
	$Fogs.visible=true
	for fog in $Fogs.get_children():
		fog.disable(false)

func end_chapter():
	set_process(true)
	$Player.set_physics_process(false)
	$ChapterScreen/ColorRect.start_fade_in(2)




func _on_color_rect_faded_in():
	var timer = get_tree().create_timer(fade_times)
	timer.timeout.connect(change_chapter)
var next_scene = preload("res://chapters/chapter3-the_decline/chapter3_house.tscn")
func change_chapter():
	get_tree().root.add_child(next_scene.instantiate())
	get_node("/root/Chapter2").queue_free()

