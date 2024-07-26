extends Node

@export var is_open: bool
@export var opened_rotation = 0.
@export var closed_rotation = 0.
@export var to_rotate: MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	to_rotate.rotation.y = (opened_rotation if is_open else closed_rotation) / 180 * PI

