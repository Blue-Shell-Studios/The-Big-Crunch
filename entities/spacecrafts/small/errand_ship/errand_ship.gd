extends Spacecraft

const SHIP_TYPE = Type.ERRAND

enum State { IDLE, MOVING, WORKING }
var current_state: State = State.IDLE

@onready var engine_sprite: AnimatedSprite2D = $EngineSprite

@onready var job_duration: Timer = $JobDuration
@onready var net: CollisionShape2D = $Net/CollisionShape2D
@onready var drill: CollisionShape2D = $Drill/CollisionShape2D

@export var target_position: Vector2 = Vector2.ZERO
@export var max_speed: float = 500.0
@export var max_acceleration: float = 800.0
@export var stopping_distance: float = 200.0
@export var rotation_speed: float = 10.0

# Mining
const MINING_POWER := 10
var asteroid : Node

# Scavenge
const GATHERING_POWER := 800
var scrap : Node

# Transport
var planets : Array

func _ready() -> void:
	type = Type.ERRAND
	
	health = 100
	
func _process(delta: float) -> void:
	if current_state == State.IDLE and task == TaskManager.Task.NONE:
		var task_args = TaskManager.get_task(type)
		task = task_args[0]
		
		match task:
			TaskManager.Task.MINE:
				asteroid = task_args[1]
				target_position = asteroid.global_position
			TaskManager.Task.SCAVENGE:
				scrap = task_args[1]
				target_position = scrap.global_position
			TaskManager.Task.TRANSPORT:
				planets = task_args[1]
				target_position = planets[0].global_position
				planets.remove_at(0)
		
		current_state = State.MOVING
		engine_sprite.play("moving")	

func target_reached() -> void:
	target_position = Vector2.ZERO
	current_state = State.WORKING
	engine_sprite.play("idle")
	perform_job()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if current_state == State.MOVING:
		navigate(state)
	else:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
	
func navigate(state: PhysicsDirectBodyState2D):
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

func perform_job() -> void:
	match task:
		TaskManager.Task.MINE:
			drill.set_deferred("disabled", false)
			job_duration.start()
			await job_duration.timeout
			drill.set_deferred("disabled", true)
			
		TaskManager.Task.SCAVENGE:
			net.set_deferred("disabled", false)
			job_duration.start()
			await job_duration.timeout
			net.set_deferred("disabled", true)
			
		TaskManager.Task.TRANSPORT:
			job_duration.start()
			await job_duration.timeout
			
			if not planets.is_empty():
				target_position = planets[0].global_position
				planets.remove_at(0)
				current_state = State.MOVING
				return
	
	task = TaskManager.Task.NONE
	current_state = State.IDLE
