extends CharacterBody3D

signal pause
signal unpause

@export var MAX_SPEED = 2.5
@export var ACCEL = 4.
const DEACCEL= 10.

var dir = Vector3()

@export var start_asleep = true
@export var hurt_after_eating = true

@export var objectives: Control
@export var monitor: Node3D

@export var can_jump = true
@export var jump_height = 0.6
@export var jump_time_to_peak = 0.6
@onready var JUMP_VELOCITY : float = ((2.0 * jump_height) / jump_time_to_peak)
@onready var gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))

@onready var camera = $RotationHelper/Camera
@onready var rotation_helper = $RotationHelper

@export var capture_mouse = true


# NOISE https://shaggydev.com/2022/02/23/screen-shake-godot/
@export var hurt_on_fall = false
@export var NOISE_SHAKE_SPEED: float = 200.0
@export var NOISE_SHAKE_STRENGTH: float = 0.1
@export var SHAKE_DECAY_RATE: float = 2.5
@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()
var noise_i: float = 0.0
var shake_strength: float = 0.0

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
	if capture_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	rand.randomize()
	noise.seed = rand.randi()
	if start_asleep:
		rotation_helper.position.y = SLEEP_POSITION
		rotation_helper.rotation.x = SLEEP_ROTATION * PI / 180.
		$RotationHelper/Camera.rotation.z = SLEEP_ROTATION * PI / 180.
		is_getting_up = true

func apply_noise_shake() -> void:
	shake_strength = NOISE_SHAKE_STRENGTH

@export var FALL_HEIGHT = 1000.
var is_airborn = -100.
func _process(delta):
	shake_strength = lerp(shake_strength, 0., SHAKE_DECAY_RATE * delta)
	var offset = get_noise_offset(delta)
	camera.h_offset = offset.x
	camera.v_offset = offset.y
	if is_on_floor():
		if is_airborn - position.y > FALL_HEIGHT :
			apply_noise_shake()
			if hurt_on_fall:
				$FallFade.modulate.a = 1.
				start_hurt(0.75, true)
		is_airborn = -100
	else:
		is_airborn = max(is_airborn, position.y)
	process_interaction()

@export var sleep_fade_time = 6.
var has_eaten = false
var has_drunk_kitchen_sink = false
var has_drunk_bowl = false
var has_drunk_bathroom_sink = false
var has_drunk_shower = false
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
			if position.z < -6:
				if not has_drunk_kitchen_sink:
					objectives.objective_got("drink")
					has_drunk_kitchen_sink = true
			elif position.z > -1:
				if position.x < 3:
					if not has_drunk_shower:
						objectives.objective_got("drink")
						has_drunk_shower = true
				else:
					if not has_drunk_bathroom_sink:
						objectives.objective_got("drink")
						has_drunk_bathroom_sink = true
			else:
				if not has_drunk_bowl:
					objectives.objective_got("drink")
					has_drunk_bowl = true
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
	if can_sleep > 0 and Input.is_action_just_pressed("interact"):
		objectives.objective_got("sleep")
		start_hurt(sleep_fade_time)
		$KeyText.visible = false
		is_the_end = true



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
var is_the_end = false
var FALL_TIME = 2.
@export var FADE_TIME = 4.
@export var UP_TIME = 4.
var SLEEP_ROTATION = 35.
var SLEEP_POSITION = 0.05
func fall(delta):
	if is_falling:
		rotation_helper.position.y = move_toward(rotation_helper.position.y, SLEEP_POSITION, (0.2-SLEEP_POSITION) / FALL_TIME * delta)
		rotation_helper.rotation.x = move_toward(rotation_helper.rotation.x, SLEEP_ROTATION * PI / 180., SLEEP_ROTATION * PI / 180 / FALL_TIME * delta)
		$RotationHelper/Camera.rotation.z = move_toward($RotationHelper/Camera.rotation.z, SLEEP_ROTATION * PI / 180., SLEEP_ROTATION * PI / 180 / FALL_TIME * delta)
		if rotation_helper.position.y <= SLEEP_POSITION+0.001 and rotation_helper.rotation.x <= SLEEP_ROTATION * PI / 180. + 0.0001 and $RotationHelper/Camera.rotation.z <=  SLEEP_ROTATION * PI / 180. + 0.0001:
			is_falling = false
			is_recovering = true
			$FallFade.start_fade_out(FADE_TIME)
	if not is_the_end and is_recovering:
		if $FallFade.modulate.a == 0.:
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
	if can_jump and is_on_floor() and Input.is_action_just_pressed("jump"):
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


@export var MOUSE_SENSITIVITY = 50
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if is_waiting_for_input:
			is_waiting_for_input = false
			is_getting_up = true
		if not is_falling and not is_recovering and not is_waiting_for_input and not is_getting_up:
			rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY / 1000.))
			self.rotate_y(-deg_to_rad(event.relative.x * MOUSE_SENSITIVITY / 1000.))
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
var can_sleep = 0
func _on_sleep_scan_area_entered(_area):
	if is_sleep_allowed:
		can_sleep += 1
		$KeyText.show_text("Sleep")
func _on_sleep_scan_area_exited(_area):
	if is_sleep_allowed:
		can_sleep -= 1
	if can_sleep == 0:
		$KeyText.fade_out()

func _on_fall_scan_area_exited(_area):
	if hurt_after_eating and has_eaten:
		has_eaten = false
		start_hurt(0.75, true)
		
func start_hurt(time, instant=false):
	is_falling = true
	velocity = Vector3.ZERO
	FALL_TIME = time
	$FallFade.start_fade_in(time)
	if instant:
		$FallFade.modulate.a = 1.

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength,
	)
