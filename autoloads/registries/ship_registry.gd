extends Node

var record : Dictionary[int, Spacecraft.Type] = {}

func _ready() -> void:
	randomize()

func record_ship(type: Spacecraft.Type) -> int:
	var ship_id : int
	while true:
		ship_id = randi_range(10000000, 99999999)
		
		if record.has(ship_id):
			continue
		
		record[ship_id] = type
		
		return ship_id
	return -1

func remove_entry(ship_id: int) -> void:
	record.erase(ship_id)

func get_ship_type(ship_id: int) -> Spacecraft.Type:
	return record[ship_id]
