class_name Projectile extends Area2D

var damage: int = 10
var velocity: Vector2

func _process(delta: float) -> void:
	if velocity == Vector2.ZERO: return
	
	global_position += velocity * delta

func hit() -> void:
	velocity = Vector2.ZERO
	$Duration.stop()
	$AnimatedSprite2D.play("hit")
	
	await $AnimatedSprite2D.animation_finished
	
	queue_free()
	
