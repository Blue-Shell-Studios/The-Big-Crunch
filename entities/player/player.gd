extends RigidBody2D

@export_group("Movement Settings")
@export var sensitivity: float = 0.4
@export var max_speed: float = 500.0
@export var friction: float = 0.92 # 1.0 = No friction, 0.0 = Instant stop
@export var rotation_speed: float = 10.0

var mouse_delta = Vector2.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta += event.relative

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Additive Momentum
	if mouse_delta != Vector2.ZERO:
		var push = mouse_delta * sensitivity * 10.0
		state.linear_velocity += push
		mouse_delta = Vector2.ZERO # Reset the buffer

	# Speed Clamping
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed

	# Gradual Halt
	state.linear_velocity *= friction

	# Rotation
	if state.linear_velocity.length() > 20:
		var target_angle = state.linear_velocity.angle()
		global_rotation = lerp_angle(global_rotation, target_angle, rotation_speed * state.step)

	# Prevent Physics Drift
	state.angular_velocity = 0

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
