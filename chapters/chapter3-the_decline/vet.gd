extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
