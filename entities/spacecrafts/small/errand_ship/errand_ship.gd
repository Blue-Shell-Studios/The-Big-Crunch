extends Spacecraft

const SHIP_TYPE = Type.ERRAND

@export var target_position: Vector2 = Vector2.ZERO
@export var max_speed: float = 300.0
@export var max_acceleration: float = 800.0
@export var stopping_distance: float = 200.0
@export var rotation_speed: float = 10.0

func _ready() -> void:
	ship_id = ShipRegistry.record_ship(SHIP_TYPE)
	
	
	SignalBus.assign_task.connect(accept_task)
	SignalBus.request_task.emit(ship_id, TaskManager.Task.NONE)
	
func _process(delta: float) -> void:
	pass

func accept_task(_ship_id: int, _task: TaskManager.Task, args: Array):
	if _ship_id != ship_id: return
	
	task = _task

func target_reached() -> void:
	target_position = Vector2.ZERO

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if target_position == Vector2.ZERO: return
	
	var to_target = target_position - global_position
	var distance = to_target.length()
	
	# Arrival Logic
	var desired_speed = max_speed
	
	if distance < stopping_distance:
		# slow down
		desired_speed = max_speed * (distance / stopping_distance)
	
	# Calculate Steering
	var desired_velocity = to_target.normalized() * desired_speed
	var steer = (desired_velocity - state.linear_velocity)
	
	# We limit the "strength" of the engine so it doesn't teleport
	var acceleration_force = steer * (max_acceleration / 10.0)
	state.apply_central_force(acceleration_force)

	# Face target
	if distance > 10:
		var target_angle = to_target.angle()
		global_rotation = lerp_angle(global_rotation, target_angle, rotation_speed * state.step)
	
	# Snap-to-Stop
	if distance < 5 and state.linear_velocity.length() < 10:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		target_reached()
