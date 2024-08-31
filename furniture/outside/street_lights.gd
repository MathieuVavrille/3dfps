extends MeshInstance3D

@export var light_on = false

func _ready():
	$SpotLight3D.visible = light_on
