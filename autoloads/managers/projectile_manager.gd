extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.spawn_projectile.connect(spawn_projectile)

func spawn_projectile(projectile: Projectile):
	add_child(projectile)
