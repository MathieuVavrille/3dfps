extends Label

@export var total = 10
var nb_collected = 0

@onready var original_text = text

var is_achieved = false

func _ready():
	set_numbered_text()

func set_numbered_text():
	text = original_text + " (" + str(nb_collected) + "/" + str(total) + ")"

func achieved():
	nb_collected += 1
	set_numbered_text()
	if nb_collected == total:
		is_achieved = true
		$TickBox/Tick.visible = true
