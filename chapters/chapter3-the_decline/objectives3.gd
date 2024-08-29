extends Node2D

signal can_sleep
signal objectives_finished

@onready var drink_objective = $CanvasLayer/Objectives/DrinkObjective
@onready var eat_objective = $CanvasLayer/Objectives/EatObjective
@onready var fish_objective = $CanvasLayer/Objectives/FishObjective
@onready var litter_objective = $CanvasLayer/Objectives/LitterObjective
@onready var hack_objective = $CanvasLayer/Objectives/HackObjective
@onready var sleep_objective = $CanvasLayer/Objectives/SleepObjective

func _ready():
	sleep_objective.visible = false

func unlock_last_objective():
	if (drink_objective.is_achieved and
		eat_objective.is_achieved and
		litter_objective.is_achieved):
		can_sleep.emit()
		sleep_objective.visible = true

func objective_got(obj_name):
	if obj_name == "drink":
		drink_objective.achieved()
	elif obj_name == "eat":
		eat_objective.achieved()
	elif obj_name == "litter":
		litter_objective.achieved()
	elif obj_name == "sleep":
		sleep_objective.achieved()
		objectives_finished.emit()
	unlock_last_objective()
	
	
var fade_in = false
var fade_out = false
var FADE_TIME = 1.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade_in:
		modulate.a = move_toward(modulate.a, 1., delta / FADE_TIME)
		$CanvasLayer/ColorRect.modulate.a = modulate.a
		$CanvasLayer/Title.modulate.a = modulate.a
		$CanvasLayer/Objectives.modulate.a = modulate.a
		if modulate.a  == 1.:
			fade_in = false
	if fade_out:
		modulate.a = move_toward(modulate.a, 0., delta / FADE_TIME)
		$CanvasLayer/ColorRect.modulate.a = modulate.a
		$CanvasLayer/Title.modulate.a = modulate.a
		$CanvasLayer/Objectives.modulate.a = modulate.a
		if modulate.a == 0.:
			fade_out = false

func start_fade_in(fade_time):
	modulate.a = 0
	fade_in = true
	FADE_TIME = fade_time
func start_fade_out(fade_time):
	modulate.a = 1.0
	fade_out = true
	FADE_TIME = fade_time
