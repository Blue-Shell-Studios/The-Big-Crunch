extends Node2D

const SCRAP_SCENE = preload("uid://boj27uu22mvnt")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.spawn_scraps.connect(spawn_scraps)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_scraps(origin: Vector2, spread: float, amount: int) -> void:
	for i in range(amount):
		var scrap = SCRAP_SCENE.instantiate()
		scrap.position = origin + Vector2(randf_range(-spread, spread), randf_range(-spread, spread))
		
		add_child.call_deferred(scrap)
		
		
