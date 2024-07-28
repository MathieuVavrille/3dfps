extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func bug():
	if $Monitor/Wall.visible:
		$Monitor/Wall.visible = false
		$Monitor/Bug1.visible = true
	elif $Monitor/Bug1.visible:
		$Monitor/Bug1.visible = false
		$Monitor/Bug2.visible = true
	elif $Monitor/Bug2.visible:
		$Monitor/Bug2.visible = false
		$Monitor/Bug3.visible = true
