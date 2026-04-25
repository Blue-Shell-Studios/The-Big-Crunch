extends PlayerVessel

const MAX_HEALTH = 10000
const COLLECTOR_POWER = 320

@onready var collector_module: CollectorModule = $CollectorModule

func _ready() -> void:
	engine_power = 500.0
	max_speed = 350.0
	max_braking_force = 350.0

	exp_requirement = 0

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
