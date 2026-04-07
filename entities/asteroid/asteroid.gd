extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const SCRAP_ON_SHATTER = 5
const MAX_HEALTH = 100
const ROTATION_VELOCITY = 1.5

var health := MAX_HEALTH:
	set(value):
		health = value
		
		if health <= 0:
			shatter()
		elif health < MAX_HEALTH * 0.5:
			sprite.play("unstable")
		else:
			sprite.play("default")

func _process(delta: float) -> void:
	rotation += ROTATION_VELOCITY * delta

func shatter() -> void:
	SignalBus.spawn_scraps.emit(global_position, 18, SCRAP_ON_SHATTER)
	
	sprite.play("shatter")
	await sprite.animation_finished
	
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("drill"):
		health -= area.get_parent().MINING_POWER
	if area.is_in_group("projectile"):
		area.hit()
		health -= area.damage
