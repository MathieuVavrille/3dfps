extends Node2D

signal can_sleep
signal objectives_finished

@onready var drink_objective = $CanvasLayer/Objectives/DrinkObjective
@onready var eat_objective = $CanvasLayer/Objectives/EatObjective
@onready var fish_objective = $CanvasLayer/Objectives/FishObjective
@onready var sleep_objective = $CanvasLayer/Objectives/SleepObjective

func unlock_last_objective():
	if drink_objective.is_achieved and eat_objective.is_achieved and fish_objective.is_achieved:
		can_sleep.emit()

func objective_got(obj_name):
	if obj_name == "drink":
		drink_objective.achieved()
	elif obj_name == "eat":
		eat_objective.achieved()
	elif obj_name == "fish":
		fish_objective.achieved()
	elif obj_name == "sleep":
		sleep_objective.achieved()
		objectives_finished.emit()
