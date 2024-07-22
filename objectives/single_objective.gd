extends Label

var is_achieved = false

func achieved():
	is_achieved = true
	$TickBox/Tick.visible = true
