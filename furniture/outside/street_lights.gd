extends MeshInstance3D

@export var light_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpotLight3D.visible = light_on


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
