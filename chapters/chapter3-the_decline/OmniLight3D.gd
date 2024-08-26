extends OmniLight3D


# Called when the node enters the scene tree for the first time.
func _ready():
	light_energy = 0.01


# Called every frame. 'delta' is the elapsed time since the previous frame.
var time = 0.
func _process(delta):
	time += delta * 1.3456
	light_energy += sin(time)/500
