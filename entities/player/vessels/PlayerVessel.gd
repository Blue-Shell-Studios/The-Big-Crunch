class_name PlayerVessel extends Area2D

enum State {IDLE, MOVING}

var state := State.IDLE

var engine_power : float
var max_speed : float
var max_braking_force : float

var exp_requirement : int

var max_health : int
var health : int :
	set(value):
		health = clamp(value, 0, max_health)
		SignalBus.update_health.emit(health, max_health)

func _process(delta: float) -> void:
	handle_input()
	manage_sprite()

func handle_input() -> void:
	pass

func manage_sprite() -> void:
	pass

func attack() -> void:
	pass
