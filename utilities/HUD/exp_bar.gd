extends ProgressBar

func _ready() -> void:
	SignalBus.update_exp.connect(update_exp_ui)

func update_exp_ui(current_exp: int, max_exp: int):
	max_value = max_exp
	value = current_exp
