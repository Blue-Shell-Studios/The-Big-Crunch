extends Area2D

var target_position : Vector2
var sucking_force : int

func _process(delta: float) -> void:
	if target_position == Vector2.ZERO: return
	var direction := global_position.direction_to(target_position)
	
	global_position += direction * sucking_force * delta
	
	if global_position.distance_to(target_position) < 5.0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("net"):
		var temp: int = area.get_parent().GATHERING_POWER
		if temp <= sucking_force: return 
		
		target_position = area.global_position
		sucking_force = temp
