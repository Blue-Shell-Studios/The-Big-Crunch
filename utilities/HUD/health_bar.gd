extends ProgressBar

@onready var health_label: Label = $HealthLabel

func _ready() -> void:
	SignalBus.update_health.connect(update_health_ui)

func update_health_ui(current_health: int, max_health: int):
	max_value = max_health
	value = current_health
	
	health_label.text = str(current_health) + " / " + str(max_health)
