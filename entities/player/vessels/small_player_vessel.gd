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
	
	#exp_requirement = 200
	exp_requirement = 10
	
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
	fire_projectile($ProjectileOrigins/PO2, player_rotation, sprite, 3)
	
	await sprite.animation_finished
	sprite.play("default")

func fire_projectile(origin: Node2D, base_rotation: float, sprite: AnimatedSprite2D, frame_num: int) -> void:
	while sprite.frame < frame_num:
		await sprite.frame_changed
	
	var projectile : Projectile = BULLET.instantiate()
	projectile.global_position = origin.global_position
	projectile.rotation = base_rotation
	projectile.velocity = Vector2.RIGHT.rotated(base_rotation) * PROJECTILE_SPEED
	SignalBus.spawn_projectile.emit(projectile)
