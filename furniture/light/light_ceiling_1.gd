extends Node3D

@export var reduce_light = false
func _ready():
	if reduce_light:
		$SpotLight3D.light_energy = 0
