extends Label

var steps: int = 0

func _ready() -> void:
	text = "Pedometer: " + str(steps)

func step():
	steps += 1
	text = "Pedometer: " + str(steps)
