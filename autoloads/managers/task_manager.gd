extends Node

enum Task {SCAVENGE, MINE, TRANSPORT, NONE}

var task_map: Dictionary[Task, Callable] = {
	Task.SCAVENGE: assign_scavenging_task,
	Task.MINE: assign_mining_task,
	Task.TRANSPORT: assign_transporting_task
}

var ship_capabilities: Dictionary[Spacecraft.Type, Array] = {
	Spacecraft.Type.ERRAND: [Task.SCAVENGE, Task.MINE, Task.TRANSPORT]
}

var num_ship_mining : int

func _ready() -> void:
	SignalBus.request_task.connect(get_task)

func get_task(ship_id: int, completed_task: Task) -> void:
	var ship_type := ShipRegistry.get_ship_type(ship_id)
	
	var assigned_task: Task = ship_capabilities[ship_type].pick_random()
	
	if task_map.has(assigned_task):
		task_map[assigned_task].call(ship_id)

func assign_mining_task(ship_id: int) -> bool:
	var asteroid_nodes := get_tree().get_nodes_in_group("asteroid")
	
	if asteroid_nodes.is_empty(): return false
	
	var asteroid_to_mine = asteroid_nodes.pick_random()
	SignalBus.assign_task.emit(ship_id, Task.MINE, [asteroid_to_mine])
	return true

func assign_transporting_task(ship_id: int) -> bool:
	return true

func assign_scavenging_task(ship_id: int) -> bool:
	return true
	
func assign_scanning_task(ship_id: int) -> bool:
	return true
