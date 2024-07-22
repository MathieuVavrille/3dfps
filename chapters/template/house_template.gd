extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in $Fish.get_children():
		child.collected.connect(fish_collected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fish_collected():
	$ObjectivesTemplate.objective_got("fish")
