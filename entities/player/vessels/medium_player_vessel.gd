extends PlayerVessel

const MAX_HEALTH = 600
const PROJECTILE_SPEED = 600
const COLLECTOR_POWER = 140

const BIG_BULLET = preload("uid://cwj7b3pgfyocp")

@onready var collector_module: CollectorModule = $CollectorModule

func _ready() -> void:
	engine_power = 700.0
	max_speed = 650.0
	max_braking_force = 550.0

	exp_requirement = 800

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
	var sprite: AnimatedSprite2D = $BodySprite
	if sprite.animation == "attack": return
	
	var player_rotation = get_parent().rotation
	
	sprite.play("attack")
	fire_projectile($ProjectileOrigins/PO1, player_rotation, sprite, 1)
	fire_projectile($ProjectileOrigins/PO2, player_rotation, sprite, 1)

	fire_projectile($ProjectileOrigins/PO3, player_rotation, sprite, 3)
	fire_projectile($ProjectileOrigins/PO4, player_rotation, sprite, 3)
	
	await sprite.animation_finished
	sprite.play("default")

func fire_projectile(origin: Node2D, base_rotation: float, sprite: AnimatedSprite2D, frame_num: int) -> void:
	while sprite.frame < frame_num:
		await sprite.frame_changed
	
	var projectile : Projectile = BIG_BULLET.instantiate()
	projectile.global_position = origin.global_position
	projectile.rotation = base_rotation
	projectile.velocity = Vector2.RIGHT.rotated(base_rotation) * PROJECTILE_SPEED
	SignalBus.spawn_projectile.emit(projectile)
