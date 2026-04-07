extends Node2D

const ERRAND_SHIP_SCENE := preload("uid://bdv3igevxcpk")
const ASSAULT_SHIP_SCENE := preload("uid://cdsltu8x37br0")
const BATTLESHIP_SCENE := preload("uid://dff0skbici111")

const SCENE_COLLECTION := [ERRAND_SHIP_SCENE, ASSAULT_SHIP_SCENE, BATTLESHIP_SCENE]

const SPAWN_LOCATION := Vector2(3709.0, 1761.0)

const INIT_NUMBER_OF_ERRAND := 10
const INIT_NUMBER_OF_ASSAULT := 3
const INIT_NUMBER_OF_BATTLESHIP := 1

const MAX_NUMBER_OF_ERRAND := 15
const MAX_NUMBER_OF_ASSAULT := 8
const MAX_NUMBER_OF_BATTLESHIP := 3

var num_of_errand: int
var num_of_assault: int
var num_of_battleship: int

func _ready() -> void:
	spawn_ship(ERRAND_SHIP_SCENE,INIT_NUMBER_OF_ERRAND)
	spawn_ship(ASSAULT_SHIP_SCENE,INIT_NUMBER_OF_ASSAULT)
	spawn_ship(BATTLESHIP_SCENE,INIT_NUMBER_OF_BATTLESHIP)
	
	num_of_errand = INIT_NUMBER_OF_ERRAND
	num_of_assault = INIT_NUMBER_OF_ASSAULT
	num_of_battleship = INIT_NUMBER_OF_BATTLESHIP

func spawn_ship(scene: Resource, num: int) -> void:
	for i in range(num):
		var ship = scene.instantiate()
		ship.global_position = SPAWN_LOCATION
		
		add_child(ship)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_cooldown_timeout() -> void:
	var scene: Resource
	while true:
		scene = SCENE_COLLECTION.pick_random()
		
		match scene:
			ERRAND_SHIP_SCENE:
				if num_of_errand >= MAX_NUMBER_OF_ERRAND: continue
				num_of_errand += 1
			ASSAULT_SHIP_SCENE:
				if num_of_assault >= MAX_NUMBER_OF_ASSAULT: continue
				num_of_assault += 1
			BATTLESHIP_SCENE:
				if num_of_battleship >= MAX_NUMBER_OF_BATTLESHIP: continue
				num_of_battleship += 1
		
		spawn_ship(scene, 1)
		break
