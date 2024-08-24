extends Node3D

@export var positions = [Vector2(3.64, 3.5), Vector2(3.64, -20.75), Vector2(-35.693, -20.75), Vector2(-35.693, -13.75), Vector2(-28.5, -13.75), Vector2(-28.5, 3.5), Vector2(3.64, 3.5)]
@export var pos_time = [0.,                  10.,                   35.,                      40.,                      45.,                    53.,                 72.]
@export var rotations = [-181.,            -180.,-90.,             -91.,0.,                    1.,90.,                  91.,0.,                  1.,90.,            91., 180.]
@export var rot_time = [0.,               9.5,10.5,             34.5,35.5,                39.5,40.5,                44.5, 45.5,              52.5,53.5,         71.,72.]

func get_t(id, time, times):
	return (time - times[id]) / (times[id + 1] - times[id])

func apply_t(t, id, vals):
	return t * vals[id + 1] + (1-t) * vals[id]

@export var current_time = 0.
var current_id = 0
var rot_id = 0
func _process(delta):
	current_time += delta
	if pos_time[current_id + 1] < current_time:
		current_id += 1
	if rot_time[rot_id + 1] < current_time:
		rot_id += 1
	if current_id >= len(positions) - 1:
		current_id = 0
		rot_id = 0
		current_time  = 0
	var t = get_t(current_id, current_time, pos_time)
	var vect = apply_t(t, current_id, positions)
	position.x = vect.x
	position.z = vect.y
	var rot_t = get_t(rot_id, current_time, rot_time)
	rotation.y = apply_t(rot_t, rot_id, rotations) * PI / 180.

