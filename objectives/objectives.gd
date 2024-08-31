extends Control

signal can_sleep
signal objectives_finished

@onready var objectives = $Objectives
@onready var sleep_objective = $SleepObjective

func _ready():
	sleep_objective.visible = false

func unlock_sleep_objective():
	for objective in objectives.get_children():
		if objective.visible and not objective.is_achieved:
			return
	can_sleep.emit()
	sleep_objective.visible = true

func objective_got(obj_name):
	if obj_name == "sleep":
		sleep_objective.achieved("sleep")
		objectives_finished.emit()
	else:
		for objective in objectives.get_children():
			objective.achieved(obj_name)
	unlock_sleep_objective()
	
	
var fade_in = false
var fade_out = false
var FADE_TIME = 1.


func _process(delta):
	if fade_in:
		modulate.a = move_toward(modulate.a, 1., delta / FADE_TIME)
		$ColorRect.modulate.a = modulate.a
		$Title.modulate.a = modulate.a
		$Objectives.modulate.a = modulate.a
		if modulate.a  == 1.:
			fade_in = false
	if fade_out:
		modulate.a = move_toward(modulate.a, 0., delta / FADE_TIME)
		$ColorRect.modulate.a = modulate.a
		$Title.modulate.a = modulate.a
		$Objectives.modulate.a = modulate.a
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
