extends Node2D

const MIN_COOLDOWN_TIME: float = 60 * 1
const MAX_COOLDOWN_TIME: float = 60 * 1.5

const CLUSTER_RADIUS := 128
const MAX_ASTEROID_COUNT := 10
const ASTEROID_SCENE := preload("uid://bpl66fwwxo6lq")

@onready var spawn_cooldown: Timer = $SpawnCooldown

var asteroid_count_limit : int

func _ready() -> void:
	randomize()
	
	spawn_cooldown.wait_time = randi_range(MIN_COOLDOWN_TIME, MAX_COOLDOWN_TIME)
	asteroid_count_limit = randi_range(1, MAX_ASTEROID_COUNT)
	spawn_asteroid(randi_range(1, asteroid_count_limit))

func spawn_asteroid(num: int):
	var spawn_count := 0
	while spawn_count < num:
		var asteroid = ASTEROID_SCENE.instantiate()
		add_child(asteroid)
		
		var angle = randf() * TAU
		var distance = randf() * CLUSTER_RADIUS
		var offset = Vector2(cos(angle), sin(angle)) * distance
		asteroid.position = offset
			
		spawn_count += 1


func _on_spawn_cooldown_timeout() -> void:
	spawn_asteroid(1)
