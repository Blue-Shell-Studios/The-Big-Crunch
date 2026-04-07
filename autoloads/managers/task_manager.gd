extends Node

enum Task {SCAVENGE, MINE, TRANSPORT, PATROL, STATION, DESTROY, NONE}

var task_map: Dictionary[Task, Callable] = {
	Task.SCAVENGE: assign_scavenging_task,
	Task.MINE: assign_mining_task,
	Task.TRANSPORT: assign_transporting_task,
	Task.PATROL: assign_patrol_task,
	Task.STATION: assign_station_task,
	Task.DESTROY: assign_destroy_task
}

var ship_capabilities: Dictionary[Spacecraft.Type, Array] = {
	Spacecraft.Type.ERRAND: [Task.SCAVENGE, Task.MINE, Task.TRANSPORT],
	Spacecraft.Type.ASSAULT: [Task.PATROL], #Task.DESTROY],
	Spacecraft.Type.BATTLESHIP: [Task.STATION] #, Task.DESTROY]
}

func get_task(ship_type: Spacecraft.Type) -> Array:
	var task : Array
	while true:
		var assigned_task: Task = ship_capabilities[ship_type].pick_random()
		
		if not task_map.has(assigned_task): continue
		
		task = task_map[assigned_task].call()
		if not task.is_empty():
			return task
	
	return []

func assign_mining_task() -> Array:
	var asteroid_nodes := get_tree().get_nodes_in_group("asteroid")
	
	if asteroid_nodes.is_empty(): return []
	
	var asteroid_to_mine = asteroid_nodes.pick_random()
	return [Task.MINE, asteroid_to_mine]

func assign_transporting_task() -> Array:
	var planet_nodes : Array[Node] = get_tree().get_nodes_in_group("planet")
	
	if planet_nodes.size() <= 1: return []
	
	var src_planet: Node = planet_nodes.pick_random()
	planet_nodes.erase(src_planet)
	var dest_planet: Node = planet_nodes.pick_random()
	
	return [Task.TRANSPORT, [src_planet, dest_planet]]

func assign_scavenging_task() -> Array:
	var scrap_nodes := get_tree().get_nodes_in_group("scrap")
	
	if scrap_nodes.is_empty(): return []
	
	var scrap_to_collect = scrap_nodes.pick_random()
	return [Task.SCAVENGE, scrap_to_collect]

func assign_patrol_task() -> Array:
	var patrol_sites := get_tree().get_nodes_in_group("patrol_site")
	
	if patrol_sites.is_empty(): return []
	
	var site_to_patrol: Node = patrol_sites.pick_random()
	var positions_to_visit := []
	for site in site_to_patrol.get_children():
		positions_to_visit.append(site.global_position)
	
	return [Task.PATROL, positions_to_visit]
 
func assign_station_task() -> Array:
	var patrol_sites := get_tree().get_nodes_in_group("patrol_site")
	
	if patrol_sites.is_empty(): return []
	
	
	var site_to_station: Node = patrol_sites.pick_random()
	return [Task.STATION, site_to_station.global_position]

func assign_destroy_task() -> Array:
	return []
