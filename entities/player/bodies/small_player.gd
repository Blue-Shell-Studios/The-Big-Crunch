extends Area2D

const BULLET = preload("uid://di8v5xcvuspeo")
const PROJECTILE_SPEED = 500

func attack():
	var player_rotation = get_parent().rotation
	var player_look_dir = Vector2.RIGHT.rotated(player_rotation)
	
	var projectile_node = BULLET.instantiate()
	projectile_node.rotation = player_rotation
	
	var projectile_origin = get_parent().global_position + player_look_dir * 14
	var projectile_velocity = player_look_dir * PROJECTILE_SPEED
	
	SignalBus.spawn_projectile.emit(projectile_node, projectile_origin, projectile_velocity)
