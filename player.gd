extends CharacterBody3D

const MAX_SPEED = 5
const ACCEL = 4
const DEACCEL= 10

var dir = Vector3()

@export var can_fall = true

@export var objectives: Node2D
@export var monitor: Node3D

@export var jump_height = 0.6
@export var jump_time_to_peak = 0.6
@onready var JUMP_VELOCITY : float = ((2.0 * jump_height) / jump_time_to_peak)
@onready var gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))

@onready var camera = $RotationHelper/Camera
@onready var rotation_helper = $RotationHelper

func copy_collision(goal, to_change):
	to_change.shape = goal.shape
	to_change.transform = goal.transform

func _ready():
	$MeshInstance3D.visible=false
	copy_collision($BodyCollision, $Scans/SleepScan/CollisionShape3D)
	copy_collision($BodyCollision, $Scans/LitterScan/CollisionShape3D)
	copy_collision($BodyCollision, $Scans/FallScan/CollisionShape3D)
	copy_collision($RotationHelper/WaterBowlScan/CollisionShape3D, $RotationHelper/FoodScan/CollisionShape3D)
	copy_collision($RotationHelper/WaterBowlScan/CollisionShape3D, $RotationHelper/HackScan/CollisionShape3D)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	process_interaction()
	freeze_cursor()
	
var has_eaten = false
func process_interaction():
	if can_eat and Input.is_action_pressed("interact"):
		if Input.is_action_just_pressed("interact"):
			has_eaten = true
			objectives.objective_got("eat")
		if not $Sound/Eating.playing:
			$Sound/Eating.play()
	else:
		$Sound/Eating.stop()
	if can_drink and Input.is_action_pressed("interact"):
		if Input.is_action_just_pressed("interact"):
			objectives.objective_got("drink")
		if not $Sound/Drinking.playing:
			$Sound/Drinking.play()
	else:
		$Sound/Drinking.stop()
	if can_litter and Input.is_action_just_pressed("interact"):
		objectives.objective_got("litter")
	if can_hack and Input.is_action_just_pressed("interact"):
		objectives.objective_got("hack")
		$Sound/Hack.play()
		monitor.bug()
	if can_sleep and Input.is_action_just_pressed("interact"):
		objectives.objective_got("sleep")

func freeze_cursor():
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta):
	if is_falling or is_recovering or is_waiting_for_input or is_getting_up:
		fall(delta)
	else:
		process_input(delta)
		process_movement(delta)


var is_falling = false
var is_recovering = false
var is_waiting_for_input = false
var is_getting_up = false
var FALL_TIME = 2
var FADE_TIME = 4
var UP_TIME = 4
func fall(delta):
	if is_falling:
		rotation_helper.position.y = move_toward(rotation_helper.position.y, 0.05, 0.15 / FALL_TIME * delta)
		rotation_helper.rotation.x = move_toward(rotation_helper.rotation.x, 35. * PI / 180., 35. * PI / 180 / FALL_TIME * delta)
		$RotationHelper/Camera.rotation.z = move_toward($RotationHelper/Camera.rotation.z, 35. * PI / 180., 35. * PI / 180 / FALL_TIME * delta)
		print(rotation_helper.position.y, " ", rotation_helper.rotation.x, " ", $RotationHelper/Camera.rotation.z)
		if rotation_helper.position.y <= 0.05001 and rotation_helper.rotation.x <= 35. * PI / 180. + 0.0001 and $RotationHelper/Camera.rotation.z <=  35. * PI / 180. + 0.0001:
			is_falling = false
			is_recovering = true
	print(is_recovering)
	if is_recovering:
		print($FallFade.modulate.a)
		$FallFade.modulate.a = move_toward($FallFade.modulate.a, 0., delta / FADE_TIME)
		if $FallFade.modulate.a == 0.:
			$FallFade.visible = false
			$FallFade.modulate.a = 1.
			is_recovering = false
			is_waiting_for_input = true
	if is_waiting_for_input and (Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("interact")):
		is_waiting_for_input = false
		is_getting_up = true
	if is_getting_up:
		rotation_helper.position.y = move_toward(rotation_helper.position.y, 0.2, 0.15 / UP_TIME * delta)
		rotation_helper.rotation.x = move_toward(rotation_helper.rotation.x, 0., 35. * PI / 180 / UP_TIME * delta)
		$RotationHelper/Camera.rotation.z = move_toward($RotationHelper/Camera.rotation.z, 0., 35. * PI / 180 / UP_TIME * delta)
		if rotation_helper.position.y >= 0.19999 and rotation_helper.rotation.x <= 0.001 and $RotationHelper/Camera.rotation.z <=  0.0001:
			is_getting_up = false

func process_input(_delta):
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
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y /= 2


func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	velocity.y += gravity * delta
	var hvel = velocity
	hvel.y = 0
	var target = dir
	target *= MAX_SPEED
	var accel = ACCEL if dir.dot(hvel) > 0 else DEACCEL
	hvel = hvel.move_toward(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	move_and_slide()


var MOUSE_SENSITIVITY = 0.05
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if is_waiting_for_input:
			is_waiting_for_input = false
			is_getting_up = true
		if not is_falling and not is_recovering and not is_waiting_for_input and not is_getting_up:
			rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY))
			self.rotate_y(-deg_to_rad(event.relative.x * MOUSE_SENSITIVITY))
			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -70, 70)
			rotation_helper.rotation_degrees = camera_rot


var can_eat = false
func _on_food_scan_area_entered(_area):
	can_eat = true
	$KeyText.show_text("Eat")
func _on_food_scan_area_exited(_area):
	can_eat = false
	$KeyText.fade_out()

var can_drink = false
func _on_water_bowl_scan_area_entered(_area):
	can_drink = true
	$KeyText.show_text("Drink")
func _on_water_bowl_scan_area_exited(_area):
	can_drink = false
	$KeyText.fade_out()

var can_litter = false
func _on_litter_scan_area_entered(_area):
	can_litter = true
	$KeyText.show_text("Use Litter")
func _on_litter_scan_area_exited(_area):
	can_litter = false
	$KeyText.fade_out()

var can_hack = false
func _on_hack_scan_area_entered(_area):
	can_hack = true
	$KeyText.show_text("Hack Computer")
func _on_hack_scan_area_exited(_area):
	can_hack = false
	$KeyText.fade_out()

var is_sleep_allowed = true
var can_sleep = false
func _on_sleep_scan_area_entered(_area):
	if is_sleep_allowed:
		can_sleep = true
		$KeyText.show_text("Sleep")
func _on_sleep_scan_area_exited(_area):
	if is_sleep_allowed:
		can_sleep = false
		$KeyText.fade_out()

func _on_fall_scan_area_exited(_area):
	if can_fall and has_eaten:
		has_eaten = false
		is_falling = true
		$FallFade.visible = true
		velocity = Vector3.ZERO

