class_name Player extends RigidBody2D

enum Stage {SMALL, MEDIUM, LARGE, MASSIVE}

const MASSIVE_PLAYER = preload("uid://cdsarwfuk2hrn")
const LARGE_PLAYER = preload("uid://dwmprv3fl0yy5")
const MEDIUM_PLAYER = preload("uid://cv8um7ekrmdgh")
const CAMERA_FORWARD_SCREEN_OFFSET = PI / 2.0

@export var rotation_speed: float = 1
@export var angular_acceleration: float = 3.5
@export_range(0.0, 1.0) var turn_control_at_max_speed: float = 0.35
@export var drift_drag: float = 35.0
@export var reverse_thrust_multiplier: float = 0.55
@export var reverse_speed_threshold: float = 45.0
@export var camera_rotation_follow_speed: float = 3.5

@onready var vessel: PlayerVessel = $SmallPlayer
@onready var camera: Camera2D = $Camera2D

var stage := Stage.SMALL
var camera_zoom_tween: Tween

var max_exp : int
var exp: int :
	set(value):
		exp = clamp(value, 0, max_exp)
		
		if max_exp > 0 and exp == max_exp:
			upgrade()
			exp = 0
		
		SignalBus.update_exp.emit(exp, max_exp)

func _ready():
	camera.global_position = global_position
	camera.global_rotation = get_camera_target_rotation()
	max_exp = vessel.exp_requirement
	exp = 0

func sync_progress_to_vessel() -> void:
	max_exp = vessel.exp_requirement
	exp = 0

func transition_camera_zoom(target_zoom: Vector2) -> void:
	if camera_zoom_tween:
		camera_zoom_tween.kill()

	camera_zoom_tween = create_tween()
	camera_zoom_tween.set_trans(Tween.TRANS_SINE)
	camera_zoom_tween.set_ease(Tween.EASE_OUT)
	camera_zoom_tween.tween_property(camera, "zoom", target_zoom, 0.8)

func get_camera_target_rotation() -> float:
	return global_rotation + CAMERA_FORWARD_SCREEN_OFFSET

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var net_force : Vector2 = Vector2.ZERO
	var turn_direction := Input.get_axis("ui_left", "ui_right")
	var throttle := Input.get_axis("ui_down", "ui_up")
	var speed_ratio: float = clamp(state.linear_velocity.length() / vessel.max_speed, 0.0, 1.0)
	var turn_control: float = lerp(1.0, turn_control_at_max_speed, speed_ratio)
	var target_angular_velocity := turn_direction * rotation_speed * turn_control
	var angular_step := angular_acceleration * state.step

	state.angular_velocity = move_toward(state.angular_velocity, target_angular_velocity, angular_step)
	var forward := Vector2.RIGHT.rotated(global_rotation)

	if throttle == 0.0:
		vessel.state = PlayerVessel.State.IDLE
		if state.linear_velocity != Vector2.ZERO:
			net_force = -state.linear_velocity.normalized() * drift_drag
	else:
		vessel.state = PlayerVessel.State.MOVING
		if throttle > 0.0:
			net_force = forward * vessel.engine_power * throttle
		elif state.linear_velocity.length() > reverse_speed_threshold:
			net_force = -state.linear_velocity.normalized() * vessel.max_braking_force
		else:
			net_force = -forward * vessel.engine_power * reverse_thrust_multiplier * abs(throttle)

	state.apply_central_force(net_force)
	
	if state.linear_velocity.length() > vessel.max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * vessel.max_speed
	
func upgrade() -> void:
	if stage == Stage.MASSIVE: return
	
	stage = (stage + 1) as Stage
	
	vessel.queue_free()
	match stage:
		Stage.MEDIUM:
			var medium_vessel = MEDIUM_PLAYER.instantiate()
			add_child(medium_vessel)
			
			vessel = medium_vessel
			sync_progress_to_vessel()
			transition_camera_zoom(Vector2(0.8, 0.8))
		Stage.LARGE:
			var large_vessel = LARGE_PLAYER.instantiate()
			add_child(large_vessel)
			
			vessel = large_vessel
			sync_progress_to_vessel()
			transition_camera_zoom(Vector2(0.7, 0.7))
		Stage.MASSIVE:
			var massive_vessel = MASSIVE_PLAYER.instantiate()
			add_child(massive_vessel)
			
			vessel = massive_vessel
			sync_progress_to_vessel()
			transition_camera_zoom(Vector2(0.5, 0.5))

func _process(delta: float) -> void:
	camera.global_position = global_position
	camera.global_rotation = lerp_angle(camera.global_rotation, get_camera_target_rotation(), camera_rotation_follow_speed * delta)

	if Input.is_action_pressed("attack"):
		vessel.attack()
