extends Control

const WORLD_RECT := Rect2(Vector2(-400.0, -400.0), Vector2(6500.0, 4000.0))
const PLAYER_COLOR := Color(0.2, 0.9, 1.0, 1.0)
const ASTEROID_COLOR := Color(0.7, 0.7, 0.75, 0.85)
const PLANET_COLOR := Color(0.2, 0.9, 0.45, 0.95)
const NPC_COLOR := Color(1.0, 0.35, 0.25, 0.95)
const BACKGROUND_COLOR := Color(0.02, 0.025, 0.04, 0.78)
const BORDER_COLOR := Color(0.35, 0.6, 0.75, 0.9)

@export var refresh_rate := 0.08

var refresh_timer := 0.0

func _process(delta: float) -> void:
	refresh_timer += delta
	if refresh_timer < refresh_rate:
		return

	refresh_timer = 0.0
	queue_redraw()

func _draw() -> void:
	var minimap_rect := Rect2(Vector2.ZERO, size)
	draw_rect(minimap_rect, BACKGROUND_COLOR, true)
	draw_rect(minimap_rect, BORDER_COLOR, false, 2.0)

	draw_group_markers("planet", PLANET_COLOR, 3.5)
	draw_group_markers("asteroid", ASTEROID_COLOR, 1.5)
	draw_group_markers("npc", NPC_COLOR, 2.0)
	draw_player_marker()

func draw_group_markers(group_name: String, color: Color, radius: float) -> void:
	for node in get_tree().get_nodes_in_group(group_name):
		var marker_node := node as Node2D
		if marker_node != null:
			draw_circle(world_to_minimap(marker_node.global_position), radius, color)

func draw_player_marker() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var player_position := world_to_minimap(player.global_position)
	var player_rotation := player.global_rotation
	var forward := Vector2.RIGHT.rotated(player_rotation) * 7.0
	var right := Vector2.RIGHT.rotated(player_rotation + PI * 0.72) * 5.0
	var left := Vector2.RIGHT.rotated(player_rotation - PI * 0.72) * 5.0

	draw_colored_polygon(PackedVector2Array([
		player_position + forward,
		player_position + right,
		player_position + left,
	]), PLAYER_COLOR)

func world_to_minimap(world_position: Vector2) -> Vector2:
	var normalized := (world_position - WORLD_RECT.position) / WORLD_RECT.size
	normalized = normalized.clamp(Vector2.ZERO, Vector2.ONE)
	return normalized * size
