class_name Scrap extends Area2D

var value : int = 1
var collector_module : CollectorModule
var target_position : Vector2
var magnetic_force : int

func _process(delta: float) -> void:
	if collector_module == null: return
	var direction := global_position.direction_to(target_position)
	
	global_position += direction * magnetic_force * delta
	
	if global_position.distance_to(target_position) < 10.0:
		var ship := collector_module.get_parent()
		if ship is PlayerVessel:
			var player: Player = ship.get_parent()
			player.exp += value
			
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("collector_module"):
		var module: CollectorModule = area
		if module.power <= magnetic_force: return 
		
		collector_module = module
		target_position = module.global_position
		magnetic_force = module.power
