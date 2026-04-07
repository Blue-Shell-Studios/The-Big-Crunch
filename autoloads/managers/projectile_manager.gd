extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.spawn_projectile.connect(spawn_projectile)

func spawn_projectile(projectile: Node2D, origin: Vector2, velocity: Vector2):
	add_child(projectile)
	projectile.global_position = origin
	projectile.velocity = velocity
