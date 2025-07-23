extends Node2D

class GridSpace:
	var occupied: bool
	var placed_item_index: int

@export var columns: int = 10
@export var rows: int = 4

var conveyor_grid = [[]]
var placed_items: Array[GroceryItem] = []

func _ready():
	for i in columns:
		conveyor_grid.append([])
		for j in rows:
			var new_space = GridSpace.new()
			new_space.placed_item_index = -1 # -1 means no item is placed
			conveyor_grid[i].append(new_space)

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	
