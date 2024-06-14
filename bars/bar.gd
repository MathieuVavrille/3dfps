extends Node2D

@export var DEPLETION_TIME = 0
 
@onready var repeat = $Value/Repeat
var repeat_min_scale = 6.227
@onready var repeat_max_scale = repeat.scale.x
@onready var end = $Value/End
var min_end = 240
@onready var max_end = end.position.x
@export var initial_value = 100
var value = 100:
	set(new_value):
		value=new_value
		if value < 0:
			value = 0
		if value > 100:
			value = 100
		set_bar()


func _ready():
	value = initial_value

func _process(delta):
	if DEPLETION_TIME != 0:
		value -= delta * 100 / DEPLETION_TIME


func set_bar():
	repeat.scale.x = (repeat_max_scale - repeat_min_scale) * value / 100 + repeat_min_scale
	repeat.position.x = repeat.scale.x * 11
	end.position.x = (max_end - min_end) * value / 100 + min_end
