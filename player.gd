extends CharacterBody3D

const MAX_SPEED = 1
const ACCEL = 4
const DEACCEL= 10

var dir = Vector3()

const SPEED = 5.0

var jump_height = 0.6
var jump_time_to_peak = 0.6
@onready var JUMP_VELOCITY : float = ((2.0 * jump_height) / jump_time_to_peak)
@onready var gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))

@onready var camera = $RotationHelper/Camera
@onready var rotation_helper = $RotationHelper

func copy_collision(goal, to_change):
	to_change.shape = goal.shape
	to_change.transform = goal.transform

func _ready():
	$MeshInstance3D.visible=false
	copy_collision($BodyCollision, $Areas/HidingScan/CollisionShape3D)
	copy_collision($BodyCollision, $Areas/HealScan/CollisionShape3D)
	copy_collision($BodyCollision, $Areas/LitterScan/CollisionShape3D)
	copy_collision($RotationHelper/WaterBowlScan/CollisionShape3D, $RotationHelper/FoodScan/CollisionShape3D)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	process_bars(delta)
	freeze_cursor()


var DRINK_TIME_TO_FULL = 5
var EAT_TIME_TO_FULL = 5
var HEALING_TIME = 10
func process_bars(delta):
	if can_eat and Input.is_action_pressed("interact"):
		$Bars/StaminaBar.value += delta * 100 / EAT_TIME_TO_FULL
		if not $Sound/Eating.playing:
			$Sound/Eating.play()
	else:
		$Sound/Eating.stop()
	if can_drink and Input.is_action_pressed("interact"):
		$Bars/WaterBar.value += delta * 100 / DRINK_TIME_TO_FULL
		if not $Sound/Drinking.playing:
			$Sound/Drinking.play()
	else:
		$Sound/Drinking.stop()
	if is_hiding:
		$Bars/HealthBar.value += delta * 100 / HEALING_TIME

func freeze_cursor():
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			#camera.environment.volumetric_fog_enabled=false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			#camera.environment.volumetric_fog_enabled=true


func _physics_process(delta):
	process_input(delta)
	process_movement(delta)


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
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY


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
		rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(-deg_to_rad(event.relative.x * MOUSE_SENSITIVITY))
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot


var is_hiding=false
func _on_hiding_scan_area_entered(_area):
	is_hiding=true
func _on_hiding_scan_area_exited(_area):
	is_hiding=false

var is_healing=false
func _on_heal_scan_area_entered(_area):
	is_healing = true
func _on_heal_scan_area_exited_(_area):
	is_healing = false
	
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
