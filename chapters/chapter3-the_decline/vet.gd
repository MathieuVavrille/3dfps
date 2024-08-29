extends Node3D

func _ready():
	$Fade.start_fade_out(4)
	$Player.set_process(false)
	$Player.set_physics_process(false)
	#$Objectives3.start_fade_in(2)
	var timer = get_tree().create_timer(2)
	timer.timeout.connect(fade_in_objectives)
	
func fade_in_objectives():
	$Objectives3.start_fade_in(2)
	$Player.set_process(true)
	$Player.set_physics_process(true)


var is_the_end = false
func _process(delta):
	if is_the_end and Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_objectives_finished():
	$PauseMenu.set_process(false)
	$Credits.start()
	is_the_end = true
	$PetBed/SleepFog.visible = false
