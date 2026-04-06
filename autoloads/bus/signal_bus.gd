extends Node

signal spawn_scraps(origin: Vector2, spread: float, amount: int)

signal request_task(ship_id: int)
signal assign_task(ship_id: int, task: TaskManager.Task, args: Array)
