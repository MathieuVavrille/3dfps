extends Label

var is_achieved = false
@export var obj_name: String

func achieved(got_name):
	if got_name == obj_name:
		is_achieved = true
		$TickBox/Tick.visible = true
