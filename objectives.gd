extends Node2D

signal can_sleep
signal objectives_finished

@onready var drink_objective = $CanvasLayer/Objectives/DrinkObjective
@onready var eat_objective = $CanvasLayer/Objectives/EatObjective
@onready var fish_objective = $CanvasLayer/Objectives/FishObjective
@onready var litter_objective = $CanvasLayer/Objectives/LitterObjective
@onready var sleep_objective = $CanvasLayer/Objectives/SleepObjective

func _ready():
	sleep_objective.visible = false

func unlock_last_objective():
	if (drink_objective.is_achieved and
		eat_objective.is_achieved and
		#fish_objective.is_achieved and 
		litter_objective.is_achieved):
		can_sleep.emit()
		sleep_objective.visible = true

func objective_got(obj_name):
	if obj_name == "drink":
		drink_objective.achieved()
	elif obj_name == "eat":
		eat_objective.achieved()
	elif obj_name == "fish":
		fish_objective.achieved()
	elif obj_name == "litter":
		litter_objective.achieved()
	elif obj_name == "sleep":
		sleep_objective.achieved()
		objectives_finished.emit()
	unlock_last_objective()
