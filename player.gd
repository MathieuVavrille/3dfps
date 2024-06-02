extends CharacterBody3D

const MAX_SPEED = 10
const ACCEL = 4
const DEACCEL= 10

var dir = Vector3()

const SPEED = 5.0

var jump_height = 0.8
var jump_time_to_peak = 0.6
@onready var JUMP_VELOCITY : float = ((2.0 * jump_height) / jump_time_to_peak)
@onready var gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))

@onready var camera = $RotationHelper/Camera
@onready var rotation_helper = $RotationHelper

func _ready():
	$MeshInstance3D.visible=false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):
	# Walking
	dir = Vector3()
	var input_movement_vector = Vector2()
	if Input.is_action_pressed("move_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("move_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("move_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_movement_vector.x += 1
	input_movement_vector = input_movement_vector.normalized()
	# Basis vectors are already normalized.
	var cam_xform = camera.get_global_transform()
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY

	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			camera.environment.volumetric_fog_enabled=false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			camera.environment.volumetric_fog_enabled=true


func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	velocity.y += gravity * delta

	var hvel = velocity
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.move_toward(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	move_and_slide()


var MOUSE_SENSITIVITY = -0.05
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY))
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot


func _on_hiding_scan_area_entered(area):
	print("hiding") # Replace with function body.


func _on_heal_scan_area_entered(area):
	print("healing") # Replace with function body.
