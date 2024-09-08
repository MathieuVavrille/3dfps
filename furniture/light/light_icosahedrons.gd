extends Node3D


@export var reduce_light = false
func _ready():
	if reduce_light:
		$Light1.light_energy = 0.1
		$Light2.light_energy = 0.1
		$Light3.light_energy = 0.1
		
