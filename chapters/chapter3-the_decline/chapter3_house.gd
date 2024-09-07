extends Node3D

var fade_times = 2.

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.set_process(false)
	$Player.set_physics_process(false)
	$Fogs.visible=false
	for fog in $Fogs.get_children():
		fog.disable(true)
	for child in $Fish.get_children():
		child.collected.connect(fish_collected)
	var timer = get_tree().create_timer(fade_times)
	timer.timeout.connect(start_chapter)
	var sound_timer = get_tree().create_timer(1.)
	sound_timer.timeout.connect($DoorCloses.play)

func start_chapter():
	$ChapterScreen.start_fade_out(fade_times)
	$ChapterScreen/Chapter.start_fade_out(fade_times/2)
	$Player.set_process(true)
	$Player.set_physics_process(true)

func fish_collected():
	$Objectives3House.objective_got("fish")

func _on_objectives_can_sleep():
	$Fogs.visible=true
	for fog in $Fogs.get_children():
		fog.disable(false)

func end_chapter():
	$ChapterScreen.modulate.a = 1.
	$ChapterScreen/ColorRect.start_fade_in(4)

func _on_color_rect_faded_in():
	var timer = get_tree().create_timer(fade_times)
	timer.timeout.connect(change_chapter)
var next_scene = preload("res://chapters/chapter3-the_decline/outside_night.tscn")
func change_chapter():
	get_tree().root.add_child(next_scene.instantiate())
	get_node("/root/Chapter3House").queue_free()

