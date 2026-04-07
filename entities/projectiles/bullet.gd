extends Projectile

func _ready() -> void:
	damage = 30

func _on_duration_timeout() -> void:
	queue_free()
