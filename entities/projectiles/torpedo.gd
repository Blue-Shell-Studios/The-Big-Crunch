extends Projectile

func _ready() -> void:
	damage = 180

func _on_duration_timeout() -> void:
	queue_free()
