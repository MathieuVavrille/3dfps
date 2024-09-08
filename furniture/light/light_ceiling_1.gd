extends Node3D


@export var reduce_light = false
func _ready():
	if reduce_light:
		$SpotLight3D.light_energy = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
