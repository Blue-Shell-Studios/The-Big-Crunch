class_name CollectorModule extends Area2D

var power : int

func set_active_status(is_active: bool) -> void:
	$CollisionShape2D.set_deferred("disabled", not is_active)
