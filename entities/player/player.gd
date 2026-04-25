class_name Player extends RigidBody2D

enum Stage {SMALL, MEDIUM, LARGE, MASSIVE}

const MASSIVE_PLAYER = preload("uid://cdsarwfuk2hrn")
const LARGE_PLAYER = preload("uid://dwmprv3fl0yy5")
const MEDIUM_PLAYER = preload("uid://cv8um7ekrmdgh")

@export var rotation_speed: float = 10.0

@onready var vessel: PlayerVessel = $SmallPlayer
@onready var camera: Camera2D = $Camera2D

var stage := Stage.SMALL
var camera_zoom_tween: Tween

var max_exp : int
var exp: int :
	set(value):
		exp = clamp(value, 0, max_exp)
		
		if exp == max_exp:
			upgrade()
			exp = 0
		
		SignalBus.update_exp.emit(exp, max_exp)

func _ready():
	max_exp = vessel.exp_requirement
	exp = 0

func transition_camera_zoom(target_zoom: Vector2) -> void:
	if camera_zoom_tween:
		camera_zoom_tween.kill()

	camera_zoom_tween = create_tween()
	camera_zoom_tween.set_trans(Tween.TRANS_SINE)
	camera_zoom_tween.set_ease(Tween.EASE_OUT)
	camera_zoom_tween.tween_property(camera, "zoom", target_zoom, 0.8)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var net_force : Vector2 = Vector2.ZERO
	var stop_threshold : float = 10

	if direction == Vector2.ZERO:
		vessel.state = PlayerVessel.State.IDLE
		
		if state.linear_velocity.length() < stop_threshold:
			# hard stop
			state.linear_velocity = Vector2.ZERO
			net_force = Vector2.ZERO
		else:
			# apply braking force
			net_force = -state.linear_velocity.normalized() * vessel.max_braking_force
	else:
		vessel.state = PlayerVessel.State.MOVING
		# accelerate
		net_force = direction * vessel.engine_power

	state.apply_central_force(net_force)
	
	# clamp velocity
	if state.linear_velocity.length() > vessel.max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * vessel.max_speed

	# Rotation
	if state.linear_velocity.length() > 20:
		var target_angle = state.linear_velocity.angle()
		global_rotation = lerp_angle(global_rotation, target_angle, rotation_speed * state.step)

	# Prevent Physics Drift
	state.angular_velocity = 0	
	
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

func _process(_delta) -> void:
	if Input.is_action_just_pressed("attack"):
		vessel.attack()
