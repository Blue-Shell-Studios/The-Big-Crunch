extends RigidBody2D

enum Stage {SMALL, MEDIUM, LARGE, MASSIVE}

const MASSIVE_PLAYER = preload("uid://cdsarwfuk2hrn")
const LARGE_PLAYER = preload("uid://dwmprv3fl0yy5")
const MEDIUM_PLAYER = preload("uid://cv8um7ekrmdgh")

@export_group("Movement Settings")
@export var sensitivity: float = 0.4
@export var max_speed: float = 800.0
@export var friction: float = 0.92 # 1.0 = No friction, 0.0 = Instant stop
@export var rotation_speed: float = 10.0

@onready var vessel: Area2D = $SmallPlayer
@onready var camera: Camera2D = $Camera2D

var is_moving := false
var stage := Stage.SMALL

var health := 150
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
	
func upgrade() -> void:
	if stage == Stage.MASSIVE: return
	
	stage += 1
	
	max_speed *= 1.2
	
	vessel.queue_free()
	match stage:
		Stage.MEDIUM:
			health = 600
			var medium_vessel = MEDIUM_PLAYER.instantiate()
			add_child(medium_vessel)
			
			vessel = medium_vessel
			camera.zoom = Vector2(0.8, 0.8)
		Stage.LARGE:
			health = 3900
			var large_vessel = LARGE_PLAYER.instantiate()
			add_child(large_vessel)
			
			vessel = large_vessel
			camera.zoom = Vector2(0.7, 0.7)
		Stage.MASSIVE:
			health = 10000
			var massive_vessel = MASSIVE_PLAYER.instantiate()
			add_child(massive_vessel)
			
			vessel = massive_vessel
			camera.zoom = Vector2(0.5, 0.5)

func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("attack"):
		vessel.attack()
