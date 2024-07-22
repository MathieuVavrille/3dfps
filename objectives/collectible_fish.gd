extends Area3D

signal collected

var ROTATION_SPEED = 1.5

func _ready():
	ROTATION_SPEED += randf()
	$Fish.rotation.y = randf() * 2 * PI

func _process(delta):
	$Fish.rotate_y(delta / ROTATION_SPEED * 2 * PI)

func _on_area_entered(area):
	collected.emit()
	queue_free()
