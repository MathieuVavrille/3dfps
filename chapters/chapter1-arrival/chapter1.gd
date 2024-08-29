extends Node3D

var fade_times = 2.
var arrow = load("res://ui/cat_paw2.png")
var beam = load("res://ui/cat_paw1.png")


func _ready():
	Input.set_custom_mouse_cursor(arrow)
	Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)
	$Movable.set_process(false)
	$Movable/pat_carrier/Player.set_process(false)
	$Cars/VehicleSports.set_process(false)
	$Cars/VehicleTruck.set_process(false)
	$PauseMenu.set_process(false)
	

func _on_play_button_pressed():
	$TitleScreen/PlayButton.disabled = true
	$TitleScreen/PlayButton.start_fade_out(fade_times)
	$TitleScreen/Controls.start_fade_out(fade_times)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_play_button_faded_out():
	$TitleScreen/Chapter.start_fade_in(fade_times)
	
func _on_chapter_faded_in():
	var timer = get_tree().create_timer(fade_times)
	timer.timeout.connect(start_chapter)

func start_chapter():
	$TitleScreen/Chapter.start_fade_out(fade_times)
	$TitleScreen.start_fade_out(fade_times)
	$Steps.play()
	$Street.play()
	$Movable.set_process(true)
	$Movable/pat_carrier/Player.set_process(true)
	$Cars/VehicleSports.set_process(true)
	$Cars/VehicleTruck.set_process(true)
	var timer = get_tree().create_timer(37)
	timer.timeout.connect(end_sub_chapter)
	$PauseMenu.set_process(true)

func end_sub_chapter():
	$TitleScreen.modulate.a = 1.
	$TitleScreen/ColorRect.start_fade_in(2)

func _on_color_rect_faded_in():
	var timer = get_tree().create_timer(0.5)
	timer.timeout.connect(get_tree().quit)
