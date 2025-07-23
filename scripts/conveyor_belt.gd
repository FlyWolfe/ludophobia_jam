extends Node2D

class GridSpace:
	var occupied: bool
	var placed_item_index: int

@export var starting_columns: int = 2
@export var conveyor_start: Vector2i = Vector2i(-9, -2)
@export var conveyor_end: Vector2i = Vector2i(8, 1)

@export var conveyor_map: TileMapLayer
@export var placing_map: TileMapLayer

@export var grocery_items: Array[GroceryItem]
@export var x_tile: Vector2i = Vector2i(7, 5)

var columns: int
var rows: int
var available_columns: int
var current_item: GroceryItem


func _ready():
	columns = conveyor_end.x - conveyor_start.x
	rows = conveyor_end.y - conveyor_start.y
	available_columns = starting_columns
	current_item = grocery_items.pick_random()

func _process(delta: float) -> void:
	var place = Input.is_action_just_released("place")
	
	placing_map.clear()
	var mouse_tile_pos = placing_map.local_to_map(placing_map.to_local(get_global_mouse_position()))
	
	var tiles_to_place: Array[Vector4i] = []
	
	for row in range(current_item.tiles.size()):
		var map_pos = mouse_tile_pos
		map_pos.y += row
		if place:
			tiles_to_place.append(Vector4i(map_pos.x, map_pos.y, current_item.tiles[row].tile_left.x, current_item.tiles[row].tile_left.y))
		if tile_on_conveyor(map_pos, current_item.tiles[row].tile_left):
			preview_tile(map_pos, current_item.tiles[row].tile_left)
			
		map_pos.x += 1
		if place:
			tiles_to_place.append(Vector4i(map_pos.x, map_pos.y, current_item.tiles[row].tile_right.x, current_item.tiles[row].tile_right.y))
		if tile_on_conveyor(map_pos, current_item.tiles[row].tile_right):
			preview_tile(map_pos, current_item.tiles[row].tile_right)
				
	if place:
		if can_place(tiles_to_place):
			for tile in tiles_to_place:
				place(Vector2i(tile.x, tile.y), Vector2i(tile.z, tile.w))
		current_item = grocery_items.pick_random()
		move_conveyor()

func preview_tile(pos: Vector2i, tile: Vector2i):
	if tile.x < 0:
		return
	if conveyor_map.get_cell_tile_data(pos) != null:
		placing_map.set_cell(pos, 0, x_tile)
		return
	placing_map.set_cell(pos, 0, tile)
	
func can_place(tiles: Array[Vector4i]):
	for tile in tiles:
		var pos = Vector2i(tile.x, tile.y)
		var tile_coords = Vector2i(tile.z, tile.w)
		if !can_place_tile(pos, tile_coords):
			return false
	return true

func tile_on_conveyor(pos: Vector2i, tile_coords: Vector2i):
	if pos.x < conveyor_start.x || pos.x > conveyor_end.x || pos.y < conveyor_start.y || pos.y > conveyor_end.y:
			return false
	#if pos.x >= conveyor_start.x + available_columns:
	#	return false
	return true

func can_place_tile(pos: Vector2i, tile_coords: Vector2i):
	if pos.x < conveyor_start.x || pos.x > conveyor_end.x || pos.y < conveyor_start.y || pos.y > conveyor_end.y:
			return false
	if pos.x >= conveyor_start.x + available_columns:
		return false
	if tile_coords.x > 0 && conveyor_map.get_cell_tile_data(pos) != null:
		return false
	return true
	
func place(pos: Vector2i, tile_coords: Vector2i):
	conveyor_map.set_cell(pos, 0, tile_coords)

func move_conveyor():
	if available_columns > columns:
		return
	 
	available_columns += 1
	for i in range(conveyor_end.x, conveyor_start.x - 1, -1):
		for j in range(conveyor_end.y, conveyor_start.y - 1, -1):
			var tile_to_left = Vector2i(-1, -1)
			if (i > conveyor_start.x):
				tile_to_left = conveyor_map.get_cell_atlas_coords(Vector2i(i - 1, j))
			conveyor_map.set_cell(Vector2i(i, j), 0, tile_to_left)
