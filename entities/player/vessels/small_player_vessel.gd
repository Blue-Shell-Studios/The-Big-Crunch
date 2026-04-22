extends PlayerVessel

const MAX_HEALTH = 150

const BULLET = preload("uid://di8v5xcvuspeo")
const PROJECTILE_SPEED = 600
const COLLECTOR_POWER = 100

@onready var collector_module: CollectorModule = $CollectorModule

func _ready() -> void:
	engine_power = 800.0
	max_speed = 800.0
	max_braking_force = 600.0
	
	exp_requirement = 200
	
	max_health = MAX_HEALTH
	health = MAX_HEALTH
	
	collector_module.power = COLLECTOR_POWER

func handle_input() -> void:
	var is_collector_active = Input.is_action_pressed("collect")
	collector_module.set_active_status(is_collector_active)

func manage_sprite() -> void:
	match state:
		State.IDLE:
			$EngineSprite.play("idle")
		State.MOVING:
			$EngineSprite.play("moving")

func attack() -> void:
	var player_rotation = get_parent().rotation
	var player_look_dir = Vector2.RIGHT.rotated(player_rotation)
	
	var projectile_node = BULLET.instantiate()
	projectile_node.rotation = player_rotation
	
	var projectile_origin = get_parent().global_position + player_look_dir * 14
	var projectile_velocity = player_look_dir * PROJECTILE_SPEED
	
	SignalBus.spawn_projectile.emit(projectile_node, projectile_origin, projectile_velocity)
	
