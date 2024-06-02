extends Node2D

@onready var repeat = $Value/Repeat
var repeat_min_scale = 6.227
@onready var repeat_max_scale = repeat.scale.x
@onready var end = $Value/End
var min_end = 240
@onready var max_end = end.position.x
var factor = -1
var value = 100:
	set(new_value):
		value=new_value
		if value < 0:
			value = 0
			factor = 0
		if value > 100:
			value = 100
			factor = -1
		set_bar()
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value += factor * delta * 25

func set_bar():
	repeat.scale.x = (repeat_max_scale - repeat_min_scale) * value / 100 + repeat_min_scale
	repeat.position.x = repeat.scale.x * 11
	end.position.x = (max_end - min_end) * value / 100 + min_end
