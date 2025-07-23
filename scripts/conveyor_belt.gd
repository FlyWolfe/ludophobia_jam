extends Node2D

@export var columns: int = 10
@export var rows: int = 4

var conveyor_grid: Array[][]

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	
